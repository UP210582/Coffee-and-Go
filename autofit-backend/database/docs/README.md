# Autofit Catalog (ACES + PIES) on PostgreSQL

This README documents the rationale, design choices, caveats, and operational guidance for the **autofit_catalog_db** schema that implements **PIES** (product/catalog data) and **ACES** (vehicle fitment) on PostgreSQL 17.x.

---

## Goals

1. **Clean separation of concerns**: PIES (products) and ACES (fitments) are distinct standards and lifecycles.
2. **Fast, forgiving search**: Accent/case-insensitive search for part names + aliases + curated marketing text, with good behavior on typos.
3. **Scalable fitment joins**: Efficient queries from vehicle → parts and parts → vehicle.
4. **Operational simplicity**: Predictable migrations, minimal reliance on server-specific features, and safe defaults.

---

## High‑level Layout

* **Database**: `autofit_catalog_db` (single DB per environment).
* **Schemas**:

  * `pies`: Products, brands, categories, attributes, assets, interchanges.
  * `aces`: Vehicles and fitment applications.
  * `public`: Extensions only (`unaccent`, `pg_trgm`, optional `ltree`) — **no app tables**.
* **Bridge**: `aces.fitment_application.part_id → pies.part.part_id` (cross‑schema FK).

Why not multiple databases? PostgreSQL can’t switch databases in SQL or perform normal joins across DBs; keeping one DB with multiple schemas enables clean joins, shared transactions, and simpler migrations.

---

## Search Strategy (Why it’s designed this way)

**Requirements**

* Users search by part name, common aliases (“balata”), and sometimes by short marketing phrases.
* Must be accent-insensitive (EN/ES), typo-tolerant, and performant at scale.

**Design**

* Normalize searchable text with `lower(unaccent(...))`:

  * `pies.part.name_normalized` keeps a lowercase, accent‑stripped copy of `display_name`.
  * `pies.part_alias.alias_norm` does the same for aliases.
* **Indexes**:

  * Trigram GIN on `name_normalized` for fast fuzzy/ILIKE‑like queries.
  * Full‑text `tsvector` columns (EN + ES) on parts and on a **rollup** table that aggregates aliases + selected marketing text.
* **Rollup**: `pies.part_search_rollup` stores concatenated aliases and marketing copy we care about (`marketing_copy`, `features`, `bullets`), with its own FTS vectors.
* **Scoring**: views expose combined vectors so queries can rank by both FTS and trigram similarity.

**Why triggers, not generated columns?**

* PostgreSQL requires expressions in **generated stored columns** to be **IMMUTABLE**. `unaccent(text)` is `STABLE`, so we maintain normalized/FTS columns via **BEFORE triggers**. This keeps the benefits of `unaccent` without violating immutability rules.

---

## Rationale for Key Choices

* **Keep extensions in `public`**: They are cluster‑wide utilities. We lock `public` down (`REVOKE CREATE FROM PUBLIC`) but keep it in the search path so `unaccent()` and trigram operators are globally usable.
* **Optional ICU collations omitted**: ICU builds differ; custom collations like `und-u-kf-secondary-ka-shifted` can fail. We rely on `unaccent+lower` instead, which is portable and works well for search and uniqueness.
* **Optional `ltree`**: Useful for hierarchical category filtering (`pies.category.path`). The schema starts with `TEXT` and upgrades to `LTREE` if the extension exists, avoiding a hard dependency.
* **Cross‑schema FK**: Fitment depends on parts, never the other way round. This mirrors the standards and simplifies ETL: load PIES first; attach ACES later.
* **FK helper indexes**: Postgres does not auto‑index FKs; explicit indexes improve join performance and reduce lock contention on deletes/updates.
* **`updated_at` hygiene**: A generic `touch_updated_at()` trigger ensures `updated_at` reflects any change, easing CDC/debugging.

---

## Data Model Primer

**PIES**

* `brand`, `category`, `part` (core). `part_alias`, `part_text`, `part_attribute`, `part_interchange`, `part_asset`, `part_package` (auxiliary).
* `part_search_rollup` aggregates search-relevant text (aliases + marketing snippets) per part.

**ACES**

* `vehicle_make`, `vehicle_model`, `vehicle_submodel`, `engine`, `transmission`, `position_ref`, `qualifier_ref` (refs).
* `fitment_application` and `fitment_application_qualifier` (main fitment records and qualifiers).

**Bridge**

* `fitment_application.part_id → pies.part.part_id`.

---

## Query Patterns

* **Fuzzy name search (accent-insensitive)**

  ```sql
  SELECT part_id, display_name
  FROM pies.part
  WHERE name_normalized ILIKE unaccent('%balata%')
  ORDER BY similarity(name_normalized, lower(unaccent('balata'))) DESC
  LIMIT 50;
  ```

* **Full‑text search (EN)**

  ```sql
  SELECT p.part_id, p.display_name,
         ts_rank_cd(v.sv_en, plainto_tsquery('english', unaccent('brake pad front'))) AS rank
  FROM pies.part_search_view v
  JOIN pies.part p USING (part_id)
  WHERE v.sv_en @@ plainto_tsquery('english', unaccent('brake pad front'))
  ORDER BY rank DESC
  LIMIT 50;
  ```

* **Vehicle → Parts**

  ```sql
  SELECT p.part_id, p.display_name
  FROM aces.fitment_application fa
  JOIN pies.part p ON p.part_id = fa.part_id
  WHERE fa.make_id = $1 AND fa.model_id = $2 AND 2020 BETWEEN fa.year_start AND fa.year_end;
  ```

---

## Uniqueness & Data Quality (Recommended)

* Add accent/case‑insensitive UNIQUE indexes after cleaning duplicates:

  * `pies.brand (lower(unaccent(name)))`
  * `aces.vehicle_make (lower(unaccent(name)))`
  * `aces.vehicle_model (make_id, lower(unaccent(name)))`
  * `aces.vehicle_submodel (model_id, lower(unaccent(name)))`
  * `pies.part (brand_id, lower(unaccent(mpn)))`
* Keep the raw UNIQUEs **or** replace them with CI/AI versions based on business rules.

---

## ETL Guidance

1. Load **PIES** first: `brand` → `category` → `part` (+ aliases/text/attributes/assets).
2. Backfill search data:

   ```sql
   UPDATE pies.part SET display_name = display_name; -- triggers normalize & set FTS
   UPDATE pies.part_alias SET alias  = alias;        -- normalize aliases
   INSERT INTO pies.part_search_rollup (part_id)
     SELECT part_id FROM pies.part ON CONFLICT DO NOTHING;
   SELECT pies.part_search_rollup_refresh(part_id) FROM pies.part;
   ```
3. Load **ACES**: refs (`make/model/...`) → `fitment_application` (+ qualifiers).

---

## Performance Notes

* Ensure **work_mem** and **maintenance_work_mem** are adequate when building GIN indexes.
* For large catalogs, consider **partitioning** `fitment_application` by `make_id` or by year range.
* Use **materialized views** for heavy vehicle facet aggregations; refresh incrementally after ETL.
* Regularly **VACUUM (ANALYZE)**; GIN indexes benefit from `vacuumdb --all --analyze-in-stages` during loads.

---

## Common Gotchas & Fixes

* **“generation expression is not immutable”**: Caused by using `unaccent()` in generated columns. We use **triggers** instead.
* **Custom ICU collations fail**: Skip ICU custom collations; rely on `unaccent+lower` and expression indexes for CI/AI.
* **`\c` fails in IDEs**: `\c` is a psql meta‑command. In GUI tools, connect to the target DB explicitly.
* **Extensions in `public`**: This is intentional. Lock it down with `REVOKE CREATE ON SCHEMA public FROM PUBLIC;`.
* **FK slow operations**: Add FK helper indexes (included) to avoid table scans and locking issues.

---

## Security & Privileges

* Roles: `autofit_owner` (DDL/admin) and `autofit_app` (app user).
* Default privileges grant app R/W in `pies` and `aces`, but no CREATE in `public`.
* Consider separate **ETL roles** with limited privileges (e.g., write to `pies` only).

---

## Testing Checklist

* Create a brand, a part with aliases and marketing text; ensure FTS and trigram queries return it.
* Create vehicle axes and a fitment; verify parts appear when filtering by make/model/year.
* Delete an alias; confirm rollup refreshes.
* Update `display_name`; confirm `name_normalized`, vectors, and `updated_at` change.

---

## Future Extensions

* **VCdb alignment**: Replace vehicle axes with official ACES/VCdb codes if licensed.
* **Inventory/Pricing**: Add separate schemas (`inventory`, `pricing`) referencing `pies.part`.
* **Row‑Level Security**: For multi‑tenant usage, add RLS policies and per‑tenant keys.
* **Search telemetry**: Store query logs to tune FTS weights and autocomplete.

---

## Operational Runbook (Quick)

* **After bulk load**: run the backfill block under *ETL Guidance*.
* **Reindex cadence**: periodically `REINDEX CONCURRENTLY` heavy GIN indexes during low‑traffic windows.
* **Backups**: hot physical backups via pgBackRest or WAL‑G; logical dumps for schema migration testing.

---

## License & Ownership

This schema is authored for the Autofit Catalog project. Adapt as needed; please include this README with any redistributed DDL.
