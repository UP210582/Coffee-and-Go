-- Quick test script to verify synthetic data loads correctly
-- Run this after synthetic_data.sql to verify data was loaded

-- Check record counts
SELECT 
  'Brands' as table_name, COUNT(*) as count FROM pies.brand
UNION ALL
SELECT 
  'Parts', COUNT(*) FROM pies.part
UNION ALL  
SELECT 
  'Categories', COUNT(*) FROM pies.category
UNION ALL
SELECT 
  'Vehicle Makes', COUNT(*) FROM aces.vehicle_make
UNION ALL
SELECT 
  'Vehicle Models', COUNT(*) FROM aces.vehicle_model
UNION ALL
SELECT 
  'Fitment Applications', COUNT(*) FROM aces.fitment_application
ORDER BY table_name;

-- Sample part with brand
SELECT p.mpn, p.display_name, b.name as brand_name
FROM pies.part p
JOIN pies.brand b ON b.brand_id = p.brand_id
LIMIT 3;

-- Sample fitment
SELECT 
  mk.name as make,
  m.name as model,
  p.display_name as part,
  fa.year_start || '-' || fa.year_end as years
FROM aces.fitment_application fa
JOIN aces.vehicle_make mk ON mk.make_id = fa.make_id
JOIN aces.vehicle_model m ON m.model_id = fa.model_id  
JOIN pies.part p ON p.part_id = fa.part_id
LIMIT 3;
