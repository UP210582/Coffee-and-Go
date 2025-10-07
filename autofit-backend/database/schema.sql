-- =====================================================================
-- PHASE 1: Roles + Database (run while connected to an existing DB)
-- =====================================================================

-- Create roles if missing
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'autofit_owner') THEN
    CREATE ROLE autofit_owner LOGIN PASSWORD 'change-me-owner' NOSUPERUSER CREATEDB CREATEROLE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'autofit_app') THEN
    CREATE ROLE autofit_app LOGIN PASSWORD 'change-me-app' NOSUPERUSER;
  END IF;
END$$;

-- Create database (must be top-level; many IDEs auto-commit, so it's fine)
-- If it already exists, this will error; run it once.
CREATE DATABASE autofit_catalog_db OWNER autofit_owner ENCODING 'UTF8';

-- psql ONLY: uncomment next line to switch
-- \c autofit_catalog_db

-- =====================================================================
-- PHASE 2: Extensions, Schemas, Security, Tables, Triggers, Indexes
-- (Run while connected to: autofit_catalog_db)
-- =====================================================================

-- ============================== Extensions ===============================
CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pg_trgm  WITH SCHEMA public;

-- Optional (taxonomy paths). We won't depend on it for table creation.
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;
EXCEPTION WHEN insufficient_privilege THEN
  RAISE NOTICE 'ltree not installed (insufficient privilege); continuing.';
END$$;

-- ============================== Lock down public =========================
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT  USAGE  ON SCHEMA public TO PUBLIC;

-- ============================== Schemas & search_path ====================
CREATE SCHEMA IF NOT EXISTS pies AUTHORIZATION autofit_owner;
CREATE SCHEMA IF NOT EXISTS aces AUTHORIZATION autofit_owner;

-- Convenience (apps can also set their own search_path)
ALTER DATABASE autofit_catalog_db SET search_path = pies, aces, public;

-- ============================== Privileges ===============================
GRANT USAGE, CREATE ON SCHEMA pies, aces TO autofit_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA pies
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES   TO autofit_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA pies
  GRANT USAGE, SELECT, UPDATE        ON SEQUENCES TO autofit_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA aces
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES   TO autofit_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA aces
  GRANT USAGE, SELECT, UPDATE        ON SEQUENCES TO autofit_app;

-- =====================================================================
-- Utility: generic updated_at auto-touch (use on any table with updated_at)
-- =====================================================================
CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END$$;

-- ============================== PIES domain ==============================

CREATE TABLE IF NOT EXISTS pies.brand (
  brand_id      BIGSERIAL PRIMARY KEY,
  name          TEXT NOT NULL,     -- optional: enforce CI/AI uniqueness later
  owner_company TEXT,
  website_url   TEXT,
  created_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (name)
);

-- Note: path starts as TEXT to avoid hard dependency on ltree.
CREATE TABLE IF NOT EXISTS pies.category (
  category_id BIGSERIAL PRIMARY KEY,
  parent_id   BIGINT REFERENCES pies.category(category_id) ON DELETE SET NULL,
  code        TEXT NOT NULL,
  name        TEXT NOT NULL,
  path        TEXT,                -- upgraded to LTREE below if available
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS pies.part (
  part_id          BIGSERIAL PRIMARY KEY,
  brand_id         BIGINT NOT NULL REFERENCES pies.brand(brand_id) ON DELETE RESTRICT,
  category_id      BIGINT REFERENCES pies.category(category_id) ON DELETE SET NULL,
  mpn              TEXT NOT NULL,  -- manufacturer part number (unique per brand)
  gtin             TEXT,           -- GTIN/UPC/EAN as-is
  display_name     TEXT NOT NULL,
  name_normalized  TEXT,           -- maintained by trigger (lower(unaccent(display_name)))
  short_desc       TEXT,
  long_desc        TEXT,
  -- FTS vectors (EN/ES) maintained by trigger
  search_vector_en tsvector,
  search_vector_es tsvector,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (brand_id, mpn)
);

CREATE TABLE IF NOT EXISTS pies.part_alias (
  alias_id    BIGSERIAL PRIMARY KEY,
  part_id     BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  alias       TEXT NOT NULL,
  alias_norm  TEXT                    -- maintained by trigger
);

CREATE TABLE IF NOT EXISTS pies.part_text (
  part_text_id BIGSERIAL PRIMARY KEY,
  part_id      BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  lang         TEXT NOT NULL CHECK (lang IN ('en','es')),
  label        TEXT NOT NULL,         -- marketing_copy, features, bullets, warranty, etc.
  content      TEXT NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (part_id, lang, label)
);

CREATE TABLE IF NOT EXISTS pies.part_attribute (
  part_attribute_id BIGSERIAL PRIMARY KEY,
  part_id           BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  attr_code         TEXT NOT NULL,    -- align with PIES attribute IDs if desired
  value_text        TEXT,
  value_num         NUMERIC,
  uom               TEXT,
  lang              TEXT CHECK (lang IN ('en','es')),
  extra             JSONB,            -- room for ranges/flags/etc.
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS pies.part_interchange (
  interchange_id BIGSERIAL PRIMARY KEY,
  part_id        BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  xref_brand     TEXT NOT NULL,
  xref_mpn       TEXT NOT NULL,
  notes          TEXT,
  UNIQUE (part_id, xref_brand, xref_mpn)
);

CREATE TABLE IF NOT EXISTS pies.part_asset (
  asset_id    BIGSERIAL PRIMARY KEY,
  part_id     BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  asset_type  TEXT NOT NULL CHECK (asset_type IN ('image','pdf','video','cad','spec')),
  uri         TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,
  alt_text    TEXT,
  lang        TEXT CHECK (lang IN ('en','es')),
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS pies.part_package (
  part_package_id BIGSERIAL PRIMARY KEY,
  part_id         BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  package_level   TEXT NOT NULL CHECK (package_level IN ('inner','each','case','pallet')),
  qty             NUMERIC(12,4) NOT NULL DEFAULT 1,
  uom_qty         TEXT,
  dim_l           NUMERIC,
  dim_w           NUMERIC,
  dim_h           NUMERIC,
  dim_uom         TEXT,
  weight          NUMERIC,
  weight_uom      TEXT,
  gtin            TEXT,
  UNIQUE (part_id, package_level)
);

-- Search rollup (aliases + marketing copy we want indexed)
CREATE TABLE IF NOT EXISTS pies.part_search_rollup (
  part_id          BIGINT PRIMARY KEY REFERENCES pies.part(part_id) ON DELETE CASCADE,
  aliases_txt      TEXT NOT NULL DEFAULT '',
  mkt_txt_en       TEXT NOT NULL DEFAULT '',
  mkt_txt_es       TEXT NOT NULL DEFAULT '',
  -- FTS vectors over rollup texts (maintained by refresh function)
  search_vector_en tsvector,
  search_vector_es tsvector
);

-- ==================== Triggers (normalize + FTS) =========================

-- Normalize part + FTS, and keep updated_at fresh
CREATE OR REPLACE FUNCTION pies.part_set_norm_and_tsv()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.name_normalized := lower(unaccent(NEW.display_name));

  NEW.search_vector_en :=
      setweight(to_tsvector('english', unaccent(coalesce(NEW.display_name,''))), 'A') ||
      setweight(to_tsvector('english', unaccent(coalesce(NEW.short_desc,''))),    'B');

  NEW.search_vector_es :=
      setweight(to_tsvector('spanish', unaccent(coalesce(NEW.display_name,''))), 'A') ||
      setweight(to_tsvector('spanish', unaccent(coalesce(NEW.short_desc,''))),    'B');

  NEW.updated_at := now();
  RETURN NEW;
END$$;

DROP TRIGGER IF EXISTS trg_part_norm_tsv ON pies.part;
CREATE TRIGGER trg_part_norm_tsv
BEFORE INSERT OR UPDATE OF display_name, short_desc ON pies.part
FOR EACH ROW EXECUTE FUNCTION pies.part_set_norm_and_tsv();

-- Also touch updated_at on other changes (e.g., is_active)
DROP TRIGGER IF EXISTS trg_part_touch_any ON pies.part;
CREATE TRIGGER trg_part_touch_any
BEFORE UPDATE ON pies.part
FOR EACH ROW
WHEN (OLD.* IS DISTINCT FROM NEW.*)   -- any change
EXECUTE FUNCTION public.touch_updated_at();

-- Normalize alias -> alias_norm
CREATE OR REPLACE FUNCTION pies.part_alias_set_norm()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.alias_norm := lower(unaccent(NEW.alias));
  RETURN NEW;
END$$;

DROP TRIGGER IF EXISTS trg_part_alias_set_norm ON pies.part_alias;
CREATE TRIGGER trg_part_alias_set_norm
BEFORE INSERT OR UPDATE OF alias ON pies.part_alias
FOR EACH ROW EXECUTE FUNCTION pies.part_alias_set_norm();

-- Rollup refresh: recompute rollup texts AND their FTS vectors
CREATE OR REPLACE FUNCTION pies.part_search_rollup_refresh(p_part_id BIGINT)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
  v_aliases TEXT;
  v_mkt_en  TEXT;
  v_mkt_es  TEXT;
BEGIN
  SELECT string_agg(a.alias, ' ') INTO v_aliases
  FROM pies.part_alias a WHERE a.part_id = p_part_id;

  SELECT string_agg(t.content, ' ') INTO v_mkt_en
  FROM pies.part_text t
  WHERE t.part_id = p_part_id AND t.lang='en' AND t.label IN ('marketing_copy','features','bullets');

  SELECT string_agg(t.content, ' ') INTO v_mkt_es
  FROM pies.part_text t
  WHERE t.part_id = p_part_id AND t.lang='es' AND t.label IN ('marketing_copy','features','bullets');

  v_aliases := coalesce(v_aliases, '');
  v_mkt_en  := coalesce(v_mkt_en , '');
  v_mkt_es  := coalesce(v_mkt_es , '');

  INSERT INTO pies.part_search_rollup (part_id, aliases_txt, mkt_txt_en, mkt_txt_es,
                                       search_vector_en, search_vector_es)
  VALUES (
    p_part_id,
    v_aliases,
    v_mkt_en,
    v_mkt_es,
    setweight(to_tsvector('english', unaccent(v_aliases)), 'A') ||
    setweight(to_tsvector('english', unaccent(v_mkt_en )), 'B'),
    setweight(to_tsvector('spanish', unaccent(v_aliases)), 'A') ||
    setweight(to_tsvector('spanish', unaccent(v_mkt_es )), 'B')
  )
  ON CONFLICT (part_id) DO UPDATE
  SET aliases_txt      = EXCLUDED.aliases_txt,
      mkt_txt_en       = EXCLUDED.mkt_txt_en,
      mkt_txt_es       = EXCLUDED.mkt_txt_es,
      search_vector_en = EXCLUDED.search_vector_en,
      search_vector_es = EXCLUDED.search_vector_es;
END$$;

-- Convenience wrappers for triggers on child tables
CREATE OR REPLACE FUNCTION pies.trg_part_search_rollup_children()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  PERFORM pies.part_search_rollup_refresh(NEW.part_id);
  RETURN NEW;
END$$;

CREATE OR REPLACE FUNCTION pies.trg_part_search_rollup_children_delete()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  PERFORM pies.part_search_rollup_refresh(OLD.part_id);
  RETURN OLD;
END$$;

-- When parts change core copy, re-rollup too (for safety)
CREATE OR REPLACE FUNCTION pies.trg_part_search_rollup_part()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  PERFORM pies.part_search_rollup_refresh(NEW.part_id);
  RETURN NEW;
END$$;

-- Triggers wiring
DROP TRIGGER IF EXISTS t_part_search_rollup_part ON pies.part;
CREATE TRIGGER t_part_search_rollup_part
AFTER INSERT OR UPDATE OF display_name, short_desc ON pies.part
FOR EACH ROW EXECUTE FUNCTION pies.trg_part_search_rollup_part();

DROP TRIGGER IF EXISTS t_alias_rollup_insupd ON pies.part_alias;
CREATE TRIGGER t_alias_rollup_insupd
AFTER INSERT OR UPDATE OF alias ON pies.part_alias
FOR EACH ROW EXECUTE FUNCTION pies.trg_part_search_rollup_children();

DROP TRIGGER IF EXISTS t_alias_rollup_delete ON pies.part_alias;
CREATE TRIGGER t_alias_rollup_delete
AFTER DELETE ON pies.part_alias
FOR EACH ROW EXECUTE FUNCTION pies.trg_part_search_rollup_children_delete();

DROP TRIGGER IF EXISTS t_text_rollup_insupd ON pies.part_text;
CREATE TRIGGER t_text_rollup_insupd
AFTER INSERT OR UPDATE OF content, lang, label ON pies.part_text
FOR EACH ROW WHEN (NEW.label IN ('marketing_copy','features','bullets'))
EXECUTE FUNCTION pies.trg_part_search_rollup_children();

DROP TRIGGER IF EXISTS t_text_rollup_delete ON pies.part_text;
CREATE TRIGGER t_text_rollup_delete
AFTER DELETE ON pies.part_text
FOR EACH ROW WHEN (OLD.label IN ('marketing_copy','features','bullets'))
EXECUTE FUNCTION pies.trg_part_search_rollup_children_delete();

-- Helpful unified search view (base + rollup vectors)
CREATE OR REPLACE VIEW pies.part_search_view AS
SELECT
  p.part_id,
  b.name AS brand,
  p.mpn,
  p.display_name,
  p.category_id,
  (p.search_vector_en || COALESCE(r.search_vector_en, ''::tsvector)) AS sv_en,
  (p.search_vector_es || COALESCE(r.search_vector_es, ''::tsvector)) AS sv_es,
  p.name_normalized
FROM pies.part p
LEFT JOIN pies.part_search_rollup r ON r.part_id = p.part_id
JOIN pies.brand b ON b.brand_id = p.brand_id
WHERE p.is_active;

-- ============================== ACES domain ===============================

CREATE TABLE IF NOT EXISTS aces.vehicle_make (
  make_id  BIGSERIAL PRIMARY KEY,
  name     TEXT NOT NULL,     -- optional: enforce CI/AI uniqueness later
  country  TEXT,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS aces.vehicle_model (
  model_id BIGSERIAL PRIMARY KEY,
  make_id  BIGINT NOT NULL REFERENCES aces.vehicle_make(make_id) ON DELETE CASCADE,
  name     TEXT NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (make_id, name)
);

CREATE TABLE IF NOT EXISTS aces.vehicle_submodel (
  submodel_id BIGSERIAL PRIMARY KEY,
  model_id    BIGINT NOT NULL REFERENCES aces.vehicle_model(model_id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (model_id, name)
);

CREATE TABLE IF NOT EXISTS aces.engine (
  engine_id       BIGSERIAL PRIMARY KEY,
  cylinders       INT,
  displacement_cc INT,
  fuel_type       TEXT,
  aspiration      TEXT,
  vin_code        TEXT
);

CREATE TABLE IF NOT EXISTS aces.transmission (
  transmission_id BIGSERIAL PRIMARY KEY,
  type        TEXT,  -- AT, MT, CVT, DCT
  speeds      INT
);

CREATE TABLE IF NOT EXISTS aces.position_ref (
  position_id BIGSERIAL PRIMARY KEY,
  code        TEXT NOT NULL,
  name        TEXT NOT NULL,
  UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS aces.qualifier_ref (
  qualifier_id BIGSERIAL PRIMARY KEY,
  code         TEXT NOT NULL,
  description  TEXT NOT NULL,
  UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS aces.fitment_application (
  application_id  BIGSERIAL PRIMARY KEY,
  part_id         BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  year_start      INT NOT NULL CHECK (year_start BETWEEN 1900 AND 2100),
  year_end        INT NOT NULL CHECK (year_end >= year_start AND year_end <= 2100),
  make_id         BIGINT NOT NULL REFERENCES aces.vehicle_make(make_id) ON DELETE RESTRICT,
  model_id        BIGINT NOT NULL REFERENCES aces.vehicle_model(model_id) ON DELETE RESTRICT,
  submodel_id     BIGINT REFERENCES aces.vehicle_submodel(submodel_id) ON DELETE RESTRICT,
  engine_id       BIGINT REFERENCES aces.engine(engine_id) ON DELETE RESTRICT,
  transmission_id BIGINT REFERENCES aces.transmission(transmission_id) ON DELETE RESTRICT,
  position_id     BIGINT REFERENCES aces.position_ref(position_id) ON DELETE RESTRICT,
  notes           TEXT,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aces.fitment_application_qualifier (
  application_id BIGINT NOT NULL REFERENCES aces.fitment_application(application_id) ON DELETE CASCADE,
  qualifier_id   BIGINT NOT NULL REFERENCES aces.qualifier_ref(qualifier_id) ON DELETE RESTRICT,
  value_text     TEXT,
  PRIMARY KEY (application_id, qualifier_id, value_text)
);

-- ============================== Indexes ==================================

-- Search (name fuzzy)
CREATE INDEX IF NOT EXISTS ix_part_name_trgm
  ON pies.part USING gin (name_normalized gin_trgm_ops);

-- FTS
CREATE INDEX IF NOT EXISTS ix_part_sv_en   ON pies.part               USING gin (search_vector_en);
CREATE INDEX IF NOT EXISTS ix_part_sv_es   ON pies.part               USING gin (search_vector_es);
CREATE INDEX IF NOT EXISTS ix_rollup_sv_en ON pies.part_search_rollup USING gin (search_vector_en);
CREATE INDEX IF NOT EXISTS ix_rollup_sv_es ON pies.part_search_rollup USING gin (search_vector_es);

-- FK helper indexes (Postgres doesn't auto-create these)
CREATE INDEX IF NOT EXISTS ix_part_brand_id         ON pies.part (brand_id);
CREATE INDEX IF NOT EXISTS ix_part_category_id      ON pies.part (category_id);
CREATE INDEX IF NOT EXISTS ix_part_alias_part_id    ON pies.part_alias (part_id);
CREATE INDEX IF NOT EXISTS ix_part_text_part_id     ON pies.part_text (part_id);
CREATE INDEX IF NOT EXISTS ix_part_attr_part_id     ON pies.part_attribute (part_id);
CREATE INDEX IF NOT EXISTS ix_part_xref_part_id     ON pies.part_interchange (part_id);
CREATE INDEX IF NOT EXISTS ix_part_asset_part_id    ON pies.part_asset (part_id);
CREATE INDEX IF NOT EXISTS ix_part_pkg_part_id      ON pies.part_package (part_id);

-- Fitment accelerators
CREATE INDEX IF NOT EXISTS ix_fitment_part            ON aces.fitment_application (part_id);
CREATE INDEX IF NOT EXISTS ix_fitment_year_make_model ON aces.fitment_application (year_start, year_end, make_id, model_id);
CREATE INDEX IF NOT EXISTS ix_fitment_engine          ON aces.fitment_application (engine_id);
CREATE INDEX IF NOT EXISTS ix_fitment_position        ON aces.fitment_application (position_id);
CREATE INDEX IF NOT EXISTS ix_model_make_id           ON aces.vehicle_model (make_id);
CREATE INDEX IF NOT EXISTS ix_submodel_model_id       ON aces.vehicle_submodel (model_id);

-- ============================== Ownership tidy ===========================
ALTER SCHEMA pies OWNER TO autofit_owner;
ALTER SCHEMA aces OWNER TO autofit_owner;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES    IN SCHEMA pies TO autofit_app;
GRANT USAGE,  SELECT, UPDATE        ON ALL SEQUENCES IN SCHEMA pies TO autofit_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES    IN SCHEMA aces TO autofit_app;
GRANT USAGE,  SELECT, UPDATE        ON ALL SEQUENCES IN SCHEMA aces TO autofit_app;

-- =====================================================================
-- OPTIONAL: If LTREE is available, upgrade pies.category.path to LTREE
-- =====================================================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_extension WHERE extname='ltree') THEN
    -- Convert non-NULL existing text to valid ltree (remove spaces/non-allowed chars)
    UPDATE pies.category
    SET path = regexp_replace(path, '[^A-Za-z0-9_.]', '_', 'g')
    WHERE path IS NOT NULL;

    -- Change column type to ltree (in-place using USING cast)
    ALTER TABLE pies.category
      ALTER COLUMN path TYPE public.ltree USING path::public.ltree;

    -- Add a GIST index for hierarchical queries
    CREATE INDEX IF NOT EXISTS ix_category_path_gist ON pies.category USING gist (path);
  END IF;
END$$;

-- =====================================================================
-- OPTIONAL (run later): Accent/Case-insensitive uniqueness hardening
--   Use CONCURRENTLY outside transactions (migrations), and only
--   after resolving duplicates.
-- =====================================================================
-- -- CREATE UNIQUE INDEX CONCURRENTLY uq_brand_name_norm
-- --   ON pies.brand ((lower(unaccent(name))));
-- -- CREATE UNIQUE INDEX CONCURRENTLY uq_make_name_norm
-- --   ON aces.vehicle_make ((lower(unaccent(name))));
-- -- CREATE UNIQUE INDEX CONCURRENTLY uq_model_make_name_norm
-- --   ON aces.vehicle_model (make_id, (lower(unaccent(name))));
-- -- CREATE UNIQUE INDEX CONCURRENTLY uq_submodel_model_name_norm
-- --   ON aces.vehicle_submodel (model_id, (lower(unaccent(name))));
-- -- CREATE UNIQUE INDEX CONCURRENTLY uq_part_brand_mpn_norm
-- --   ON pies.part (brand_id, (lower(unaccent(mpn))))
-- --   WHERE mpn IS NOT NULL;

-- =====================================================================
-- OPTIONAL: Backfill/refresh utilities after bulk loads
-- =====================================================================
-- Normalize parts + FTS (forces BEFORE trigger evaluation)
-- UPDATE pies.part p SET display_name = p.display_name;
-- Normalize aliases
-- UPDATE pies.part_alias a SET alias = a.alias;
-- Build rollups for all parts
-- INSERT INTO pies.part_search_rollup (part_id) SELECT part_id FROM pies.part
--   ON CONFLICT DO NOTHING;
-- SELECT pies.part_search_rollup_refresh(part_id) FROM pies.part;
