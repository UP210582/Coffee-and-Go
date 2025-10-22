-- =====================================================================
-- PHASE 1: Roles + Database (run while connected to an existing DB)
-- =====================================================================

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'autofit_owner') THEN
    CREATE ROLE autofit_owner LOGIN PASSWORD 'change-me-owner' NOSUPERUSER CREATEDB CREATEROLE;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'autofit_app') THEN
    CREATE ROLE autofit_app LOGIN PASSWORD 'change-me-app' NOSUPERUSER;
  END IF;
END$$;

CREATE DATABASE autofit_catalog_db OWNER autofit_owner ENCODING 'UTF8';
\c autofit_catalog_db

-- =====================================================================
-- PHASE 2: Extensions, Schemas, Security, Tables, Triggers, Indexes
-- =====================================================================

-- Core extensions
CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pg_trgm  WITH SCHEMA public;

-- Try to enable ltree; non-fatal if not permitted
DO $$
BEGIN
  BEGIN
    CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;
  EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE 'ltree not installed (insufficient privilege); continuing.';
  END;
END$$;

-- Lock down public a bit
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT  USAGE  ON SCHEMA public TO PUBLIC;

-- App schemas
CREATE SCHEMA IF NOT EXISTS pies AUTHORIZATION autofit_owner;
CREATE SCHEMA IF NOT EXISTS aces AUTHORIZATION autofit_owner;

-- Optional convenience
ALTER DATABASE autofit_catalog_db SET search_path = pies, aces, public;

-- Default privileges for app role
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
-- Utility: updated_at toucher (generic)
-- =====================================================================
CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END$$;

-- =====================================================================
-- PIES: Helpers for category label/path
-- =====================================================================

-- Sanitize a code into a valid "label": letters/digits/_ only, must start with a letter.
-- Immutable so it can be used in generated columns.
CREATE OR REPLACE FUNCTION pies.ltree_label(src text)
RETURNS text
LANGUAGE sql
IMMUTABLE
RETURNS NULL ON NULL INPUT
AS $$
  SELECT
    CASE
      WHEN src IS NULL OR src = '' THEN NULL
      ELSE
        -- normalize to lowercase, replace disallowed with '_'
        CASE
          WHEN substring(lower(src) FROM '^[a-z]') IS NOT NULL
            THEN regexp_replace(lower(src), '[^a-z0-9_]', '_', 'g')
          ELSE '_' || regexp_replace(lower(src), '[^a-z0-9_]', '_', 'g')
        END
    END
$$;

-- TEXT path trigger (portable): builds dotted path from parent.path + code_label
CREATE OR REPLACE FUNCTION pies.category_set_path_text()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE parent_path text;
BEGIN
  -- derive label from NEW.code
  NEW.code_label := pies.ltree_label(NEW.code);

  IF NEW.parent_id IS NULL THEN
    NEW.path := NEW.code_label;
  ELSE
    SELECT path INTO parent_path FROM pies.category WHERE category_id = NEW.parent_id;
    IF parent_path IS NULL OR parent_path = '' THEN
      NEW.path := NEW.code_label;
    ELSE
      NEW.path := parent_path || '.' || NEW.code_label;
    END IF;
  END IF;

  RETURN NEW;
END$$;

-- LTREE path trigger (only used after upgrade)
-- Uses text2ltree and ltree concatenation operator ||
CREATE OR REPLACE FUNCTION pies.category_set_path_ltree()
RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE parent_path ltree;
BEGIN
  NEW.code_label := pies.ltree_label(NEW.code);

  IF NEW.parent_id IS NULL THEN
    NEW.path := text2ltree(NEW.code_label);
  ELSE
    SELECT path INTO parent_path FROM pies.category WHERE category_id = NEW.parent_id;
    IF parent_path IS NULL THEN
      NEW.path := text2ltree(NEW.code_label);
    ELSE
      NEW.path := parent_path || text2ltree(NEW.code_label);
    END IF;
  END IF;

  RETURN NEW;
END$$;

-- =====================================================================
-- PIES domain
-- =====================================================================

CREATE TABLE IF NOT EXISTS pies.brand (
  brand_id      BIGSERIAL PRIMARY KEY,
  name          TEXT NOT NULL,
  owner_company TEXT,
  website_url   TEXT,
  created_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (name)
);

-- Start with TEXT path; we will optionally upgrade to LTREE later.
CREATE TABLE IF NOT EXISTS pies.category (
  category_id BIGSERIAL PRIMARY KEY,
  parent_id   BIGINT REFERENCES pies.category(category_id) ON DELETE SET NULL,
  code        TEXT NOT NULL,
  name        TEXT NOT NULL,
  -- materialized path (TEXT now; can become LTREE)
  path        TEXT,
  -- generated label we derive the path from (safe for ltree labels)
  code_label  TEXT GENERATED ALWAYS AS (pies.ltree_label(code)) STORED,
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (code)
);

-- Wire the TEXT path trigger by default (portable)
DROP TRIGGER IF EXISTS trg_category_path_txt ON pies.category;
CREATE TRIGGER trg_category_path_txt
BEFORE INSERT OR UPDATE OF parent_id, code ON pies.category
FOR EACH ROW EXECUTE FUNCTION pies.category_set_path_text();

CREATE TABLE IF NOT EXISTS pies.part (
  part_id          BIGSERIAL PRIMARY KEY,
  brand_id         BIGINT NOT NULL REFERENCES pies.brand(brand_id) ON DELETE RESTRICT,
  category_id      BIGINT REFERENCES pies.category(category_id) ON DELETE SET NULL,
  mpn              TEXT NOT NULL,
  gtin             TEXT,
  display_name     TEXT NOT NULL,
  name_normalized  TEXT,
  short_desc       TEXT,
  long_desc        TEXT,
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
  alias_norm  TEXT
);

CREATE TABLE IF NOT EXISTS pies.part_text (
  part_text_id BIGSERIAL PRIMARY KEY,
  part_id      BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  lang         TEXT NOT NULL CHECK (lang IN ('en','es')),
  label        TEXT NOT NULL,
  content      TEXT NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now(),
  UNIQUE (part_id, lang, label)
);

CREATE TABLE IF NOT EXISTS pies.part_attribute (
  part_attribute_id BIGSERIAL PRIMARY KEY,
  part_id           BIGINT NOT NULL REFERENCES pies.part(part_id) ON DELETE CASCADE,
  attr_code         TEXT NOT NULL,
  value_text        TEXT,
  value_num         NUMERIC,
  uom               TEXT,
  lang              TEXT CHECK (lang IN ('en','es')),
  extra             JSONB,
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

CREATE TABLE IF NOT EXISTS pies.part_search_rollup (
  part_id          BIGINT PRIMARY KEY REFERENCES pies.part(part_id) ON DELETE CASCADE,
  aliases_txt      TEXT NOT NULL DEFAULT '',
  mkt_txt_en       TEXT NOT NULL DEFAULT '',
  mkt_txt_es       TEXT NOT NULL DEFAULT '',
  search_vector_en tsvector,
  search_vector_es tsvector
);

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

DROP TRIGGER IF EXISTS trg_part_touch_any ON pies.part;
CREATE TRIGGER trg_part_touch_any
BEFORE UPDATE ON pies.part
FOR EACH ROW
WHEN (OLD.* IS DISTINCT FROM NEW.*)
EXECUTE FUNCTION public.touch_updated_at();

-- Alias normalization
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

-- Rollup refresh
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

CREATE OR REPLACE FUNCTION pies.trg_part_search_rollup_part()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  PERFORM pies.part_search_rollup_refresh(NEW.part_id);
  RETURN NEW;
END$$;

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

-- Unified search view
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

-- =====================================================================
-- ACES domain
-- =====================================================================

CREATE TABLE IF NOT EXISTS aces.vehicle_make (
  make_id  BIGSERIAL PRIMARY KEY,
  name     TEXT NOT NULL,
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
  type        TEXT,
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

-- =====================================================================
-- Indexes
-- =====================================================================

-- Search (name fuzzy)
CREATE INDEX IF NOT EXISTS ix_part_name_trgm
  ON pies.part USING gin (name_normalized public.gin_trgm_ops);

-- FTS
CREATE INDEX IF NOT EXISTS ix_part_sv_en   ON pies.part               USING gin (search_vector_en);
CREATE INDEX IF NOT EXISTS ix_part_sv_es   ON pies.part               USING gin (search_vector_es);
CREATE INDEX IF NOT EXISTS ix_rollup_sv_en ON pies.part_search_rollup USING gin (search_vector_en);
CREATE INDEX IF NOT EXISTS ix_rollup_sv_es ON pies.part_search_rollup USING gin (search_vector_es);

-- FK helpers
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

-- =====================================================================
-- Ownership tidy
-- =====================================================================
ALTER SCHEMA pies OWNER TO autofit_owner;
ALTER SCHEMA aces OWNER TO autofit_owner;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES    IN SCHEMA pies TO autofit_app;
GRANT USAGE,  SELECT, UPDATE        ON ALL SEQUENCES IN SCHEMA pies TO autofit_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES    IN SCHEMA aces TO autofit_app;
GRANT USAGE,  SELECT, UPDATE        ON ALL SEQUENCES IN SCHEMA aces TO autofit_app;

-- =====================================================================
-- OPTIONAL: Upgrade pies.category.path to LTREE (idempotent & safe)
-- =====================================================================

DO $$
DECLARE
  v_coltype_oid oid;
  v_ltree_oid   oid := to_regtype('ltree');   -- NULL if ltree absent
BEGIN
  IF v_ltree_oid IS NULL THEN
    RAISE NOTICE 'ltree not available; leaving pies.category.path as TEXT.';
    RETURN;
  END IF;

  -- Current type of pies.category.path
  SELECT a.atttypid
  INTO v_coltype_oid
  FROM pg_catalog.pg_attribute a
  JOIN pg_catalog.pg_class c ON c.oid = a.attrelid
  JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = 'pies'
    AND c.relname = 'category'
    AND a.attname = 'path'
    AND NOT a.attisdropped;

  IF v_coltype_oid = v_ltree_oid THEN
    -- Already LTREE: nothing to convert; (re)create LTREE trigger & indexes
    EXECUTE 'DROP TRIGGER IF EXISTS trg_category_path_txt ON pies.category';
    EXECUTE 'DROP TRIGGER IF EXISTS trg_category_path_ltree ON pies.category';
    EXECUTE 'CREATE TRIGGER trg_category_path_ltree
             BEFORE INSERT OR UPDATE OF parent_id, code ON pies.category
             FOR EACH ROW EXECUTE FUNCTION pies.category_set_path_ltree()';

    CREATE INDEX IF NOT EXISTS ix_category_path_gist ON pies.category USING gist (path);
    CREATE INDEX IF NOT EXISTS ix_category_level     ON pies.category (nlevel(path));

  ELSIF v_coltype_oid = 'text'::regtype THEN
    -- Sanitize existing TEXT paths (strict label rules)
    EXECUTE $sql$
      UPDATE pies.category
      SET path = regexp_replace(path::text, '[^A-Za-z0-9_.]', '_', 'g')
      WHERE path IS NOT NULL
    $sql$;

    -- Convert column to LTREE
    EXECUTE 'ALTER TABLE pies.category
             ALTER COLUMN path TYPE ltree USING path::ltree';

    -- Swap triggers: remove TEXT, add LTREE
    EXECUTE 'DROP TRIGGER IF EXISTS trg_category_path_txt ON pies.category';
    EXECUTE 'DROP TRIGGER IF EXISTS trg_category_path_ltree ON pies.category';
    EXECUTE 'CREATE TRIGGER trg_category_path_ltree
             BEFORE INSERT OR UPDATE OF parent_id, code ON pies.category
             FOR EACH ROW EXECUTE FUNCTION pies.category_set_path_ltree()';

    -- LTREE indexes
    CREATE INDEX IF NOT EXISTS ix_category_path_gist ON pies.category USING gist (path);
    CREATE INDEX IF NOT EXISTS ix_category_level     ON pies.category (nlevel(path));

  ELSE
    RAISE EXCEPTION 'Unexpected pies.category.path type: %', v_coltype_oid::regtype;
  END IF;
END$$;

-- =====================================================================
-- OPTIONAL: If LTREE is NOT available, add a helper index for TEXT path
-- (prefix scans & LIKE '^foo.%' are helped by pg_trgm)
-- =====================================================================
DO $$
BEGIN
  IF to_regtype('ltree') IS NULL THEN
    -- trigram index on TEXT path for prefix/contains queries
    CREATE INDEX IF NOT EXISTS ix_category_path_trgm
      ON pies.category USING gin (path public.gin_trgm_ops);
  END IF;
END$$;

-- =====================================================================
-- OPTIONAL: Post-load utilities (run later)
-- =====================================================================
-- -- Recompute TEXT paths via trigger (portable)
-- -- UPDATE pies.category c SET code = c.code;

-- -- Build rollups for all parts
-- -- INSERT INTO pies.part_search_rollup (part_id) SELECT part_id FROM pies.part
-- --   ON CONFLICT DO NOTHING;
-- -- SELECT pies.part_search_rollup_refresh(part_id) FROM pies.part;
