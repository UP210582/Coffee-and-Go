# Database Queries and Sample Data

This directory contains SQL scripts for working with the AutoFit Catalog database.

## Files

### `synthetic_data.sql`
Complete synthetic dataset that populates the ACES/PIES catalog with realistic automotive aftermarket data:

- **12 major brands** (ACDelco, Bosch, Wagner, FRAM, NGK, etc.)
- **27 different parts** across multiple categories:
  - Brake components (pads, rotors, calipers)
  - Filters (oil, air, cabin)
  - Ignition (spark plugs, coils)
  - Suspension (shocks, struts, control arms)
  - Engine (belts, hoses)
- **12 vehicle makes** with 26 models and submodels
- **55 fitment applications** (2013-2024 model years)
- **Multilingual support** (English/Spanish)
- **Complete auxiliary data**:
  - Part aliases and colloquial terms
  - Technical attributes and specifications
  - Cross-references between brands
  - Digital assets (images, PDFs, videos)
  - Packaging information

### `load_synthetic_data.sh`
Bash script to easily load the synthetic data into your database.

### `search.sql`
Example search queries demonstrating full-text and fuzzy search capabilities.

### `sample_data.sql`
(Reserved for production-like sample data)

## Loading Synthetic Data

### Prerequisites
1. Database must exist and schema must be applied:
   ```bash
   cd ../
   psql -U postgres -f schema.sql
   ```

2. Ensure you're connected to the correct database:
   ```bash
   psql -U autofit_owner -d autofit_catalog_db
   ```

### Method 1: Using the Loader Script
```bash
chmod +x load_synthetic_data.sh
./load_synthetic_data.sh
```

### Method 2: Direct PostgreSQL Command
```bash
psql -U autofit_owner -d autofit_catalog_db -f synthetic_data.sql
```

### Method 3: Within psql Session
```sql
\c autofit_catalog_db
\i synthetic_data.sql
```

## Script Behavior

The `synthetic_data.sql` script:

1. **Starts a transaction** for atomicity
2. **Clears existing data** in proper order (respecting foreign keys)
3. **Resets sequences** to start from 1
4. **Loads PIES data** (brands → categories → parts → attributes)
5. **Loads ACES data** (vehicles → engines → transmissions → fitments)
6. **Builds search indexes** (normalizes text, creates FTS vectors)
7. **Commits transaction** if all successful

## Data Highlights

### Realistic Part Coverage
- **Brake Systems**: Multiple pad materials (ceramic, semi-metallic), rotors (vented, slotted)
- **Filters**: Coverage for common maintenance items with proper change intervals
- **Ignition**: From basic copper to premium iridium spark plugs
- **Suspension**: Complete strut assemblies and individual components

### Vehicle Coverage
Popular vehicles from major manufacturers:
- **Domestic**: Ford F-150, Chevrolet Silverado, Jeep Cherokee
- **Japanese**: Toyota Camry/RAV4, Honda Accord/CR-V, Nissan Altima
- **European**: BMW 3 Series, Mercedes C-Class, Volkswagen Jetta

### Cross-References
Parts include accurate cross-references showing interchangeability:
- Wagner ZD1432 ↔ Raybestos EHT1432 ↔ ACDelco 14D1432CH
- FRAM PH9837 ↔ WIX 57356 ↔ ACDelco PF63E

### Multilingual Search
Spanish aliases for common terms:
- "balatas" → brake pads
- "filtro de aceite" → oil filter
- "bujías" → spark plugs
- "amortiguadores" → shock absorbers

## Verification Queries

After loading, verify the data:

```sql
-- Count loaded records
SELECT 
  (SELECT COUNT(*) FROM pies.brand) as brands,
  (SELECT COUNT(*) FROM pies.part) as parts,
  (SELECT COUNT(*) FROM aces.vehicle_model) as models,
  (SELECT COUNT(*) FROM aces.fitment_application) as fitments;

-- Find parts for 2020 Toyota Camry
SELECT p.mpn, p.display_name, b.name as brand
FROM aces.fitment_application fa
JOIN pies.part p ON p.part_id = fa.part_id
JOIN pies.brand b ON b.brand_id = p.brand_id
JOIN aces.vehicle_model m ON m.model_id = fa.model_id
JOIN aces.vehicle_make mk ON mk.make_id = fa.make_id
WHERE mk.name = 'Toyota' AND m.name = 'Camry'
  AND 2020 BETWEEN fa.year_start AND fa.year_end
ORDER BY p.display_name;

-- Search by Spanish term
SELECT p.display_name, pa.alias
FROM pies.part p
JOIN pies.part_alias pa ON pa.part_id = p.part_id
WHERE pa.alias_norm ILIKE '%balata%';

-- Full-text search
SELECT p.display_name, 
  ts_rank_cd(sv_en, plainto_tsquery('english', 'ceramic brake')) as rank
FROM pies.part_search_view
WHERE sv_en @@ plainto_tsquery('english', 'ceramic brake')
ORDER BY rank DESC LIMIT 5;
```

## Troubleshooting

### Foreign Key Errors
The script handles deletion and insertion in the correct order. If you get FK errors:
1. Ensure you're running the complete script (it uses transactions)
2. Check that the database schema is properly installed first

### Sequence Errors
If you get duplicate key errors:
1. The script resets sequences before inserting
2. Make sure no other sessions are inserting data simultaneously

### Performance
For large production datasets:
1. Consider disabling triggers during load
2. Run VACUUM ANALYZE after loading
3. Use COPY instead of INSERT for bulk loads

## Notes

- This synthetic data is designed for testing and development
- All URLs and assets are examples and won't resolve to real resources
- Part numbers and specifications are realistic but may not match actual products
- The data demonstrates ACES/PIES compliance while remaining manageable in size
