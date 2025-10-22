-- Full-text EN:
SELECT p.part_id, p.display_name, ts_rank_cd(v.sv_en, plainto_tsquery('english', unaccent('brake pad front'))) AS rank
FROM pies.part_search_view v
JOIN pies.part p USING (part_id)
WHERE v.sv_en @@ plainto_tsquery('english', unaccent('brake pad front'))
ORDER BY rank DESC
LIMIT 50;

-- Fuzzy (ILIKE-like) via trigram, accent-insensitive:
SELECT part_id, display_name
FROM pies.part
WHERE name_normalized ILIKE unaccent('%balata%')
ORDER BY similarity(name_normalized, lower(unaccent('balata'))) DESC
LIMIT 50;