-- =====================================================================
-- Synthetic Data for ACES/PIES Automotive Aftermarket Catalog
-- =====================================================================
-- This script populates the database with realistic automotive parts data
-- covering brake systems, filters, ignition, suspension, and more.
-- Includes multilingual support (EN/ES) and complete vehicle fitment data.
--
-- PREREQUISITES: The database schema must be created first:
--   psql -U postgres -f ../schema.sql
--
-- USAGE: Run this script while connected to the autofit_catalog_db database
--   psql -U autofit_owner -d autofit_catalog_db -f synthetic_data.sql
-- =====================================================================

-- Check if schemas exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'pies') THEN
        RAISE EXCEPTION 'Schema "pies" does not exist. Please run schema.sql first.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'aces') THEN
        RAISE EXCEPTION 'Schema "aces" does not exist. Please run schema.sql first.';
    END IF;
END $$;

BEGIN;  -- Start transaction for atomicity

-- =====================================================================
-- STEP 1: Clear existing data (respecting foreign key constraints)
-- =====================================================================
-- Use TRUNCATE CASCADE for efficiency and to handle dependencies
-- If tables don't exist, this will fail gracefully

DO $$
BEGIN
    -- Clear ACES fitment data first (depends on both ACES and PIES)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'fitment_application_qualifier') THEN
        TRUNCATE TABLE aces.fitment_application_qualifier CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'fitment_application') THEN
        TRUNCATE TABLE aces.fitment_application CASCADE;
    END IF;
    
    -- Clear ACES reference data
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'position_ref') THEN
        TRUNCATE TABLE aces.position_ref CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'qualifier_ref') THEN
        TRUNCATE TABLE aces.qualifier_ref CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'transmission') THEN
        TRUNCATE TABLE aces.transmission CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'engine') THEN
        TRUNCATE TABLE aces.engine CASCADE;
    END IF;
    
    -- Clear ACES vehicle hierarchy
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'vehicle_submodel') THEN
        TRUNCATE TABLE aces.vehicle_submodel CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'vehicle_model') THEN
        TRUNCATE TABLE aces.vehicle_model CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'vehicle_make') THEN
        TRUNCATE TABLE aces.vehicle_make CASCADE;
    END IF;
    
    -- Clear PIES auxiliary data
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_search_rollup') THEN
        TRUNCATE TABLE pies.part_search_rollup CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_package') THEN
        TRUNCATE TABLE pies.part_package CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_asset') THEN
        TRUNCATE TABLE pies.part_asset CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_interchange') THEN
        TRUNCATE TABLE pies.part_interchange CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_attribute') THEN
        TRUNCATE TABLE pies.part_attribute CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_text') THEN
        TRUNCATE TABLE pies.part_text CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part_alias') THEN
        TRUNCATE TABLE pies.part_alias CASCADE;
    END IF;
    
    -- Clear PIES core data
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part') THEN
        TRUNCATE TABLE pies.part CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'category') THEN
        TRUNCATE TABLE pies.category CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'brand') THEN
        TRUNCATE TABLE pies.brand CASCADE;
    END IF;
END $$;

-- =====================================================================
-- PIES DATA
-- =====================================================================

-- =====================================================================
-- STEP 2: Insert PIES data (base tables first)
-- =====================================================================

-- Brands (Major aftermarket manufacturers)
INSERT INTO pies.brand (brand_id, name, owner_company, website_url) VALUES
(1, 'ACDelco', 'General Motors Company', 'https://www.acdelco.com'),
(2, 'Bosch', 'Robert Bosch GmbH', 'https://www.bosch.com'),
(3, 'Wagner', 'Federal-Mogul Motorparts', 'https://www.wagnerbrake.com'),
(4, 'Raybestos', 'Brake Parts Inc', 'https://www.raybestos.com'),
(5, 'FRAM', 'FRAM Group Operations LLC', 'https://www.fram.com'),
(6, 'Wix Filters', 'Mann+Hummel', 'https://www.wixfilters.com'),
(7, 'NGK', 'NGK Spark Plugs', 'https://www.ngksparkplugs.com'),
(8, 'Denso', 'DENSO Corporation', 'https://www.denso.com'),
(9, 'Monroe', 'Tenneco Inc.', 'https://www.monroe.com'),
(10, 'KYB', 'KYB Corporation', 'https://www.kyb.com'),
(11, 'Moog', 'Federal-Mogul Motorparts', 'https://www.moogparts.com'),
(12, 'Gates', 'Gates Corporation', 'https://www.gates.com');

-- Update sequence to continue after our inserts
SELECT setval('pies.brand_brand_id_seq', 12, true);

-- Categories (PIES-like structure)
INSERT INTO pies.category (category_id, parent_id, code, name, path) VALUES
(1, NULL, 'BRAKE', 'Brake Systems', 'BRAKE'),
(2, 1, 'BRAKE_PAD', 'Brake Pads', 'BRAKE.PAD'),
(3, 1, 'BRAKE_ROTOR', 'Brake Rotors', 'BRAKE.ROTOR'),
(4, 1, 'BRAKE_CALIPER', 'Brake Calipers', 'BRAKE.CALIPER'),
(5, NULL, 'FILTER', 'Filters', 'FILTER'),
(6, 5, 'FILTER_OIL', 'Oil Filters', 'FILTER.OIL'),
(7, 5, 'FILTER_AIR', 'Air Filters', 'FILTER.AIR'),
(8, 5, 'FILTER_CABIN', 'Cabin Air Filters', 'FILTER.CABIN'),
(9, NULL, 'IGNITION', 'Ignition System', 'IGNITION'),
(10, 9, 'SPARK_PLUG', 'Spark Plugs', 'IGNITION.PLUG'),
(11, 9, 'IGNITION_COIL', 'Ignition Coils', 'IGNITION.COIL'),
(12, NULL, 'SUSPENSION', 'Suspension', 'SUSPENSION'),
(13, 12, 'SHOCK', 'Shock Absorbers', 'SUSPENSION.SHOCK'),
(14, 12, 'STRUT', 'Struts', 'SUSPENSION.STRUT'),
(15, 12, 'CONTROL_ARM', 'Control Arms', 'SUSPENSION.CONTROL_ARM'),
(16, NULL, 'BELT_HOSE', 'Belts & Hoses', 'BELT_HOSE'),
(17, 16, 'BELT_SERP', 'Serpentine Belts', 'BELT_HOSE.BELT_SERP'),
(18, 16, 'HOSE_RAD', 'Radiator Hoses', 'BELT_HOSE.HOSE_RAD');

SELECT setval('pies.category_category_id_seq', 18, true);

-- Parts (Various automotive parts)
INSERT INTO pies.part (part_id, brand_id, category_id, mpn, gtin, display_name, short_desc, long_desc, is_active) VALUES
-- Brake Pads
(1, 3, 2, 'ZD1432', '00810038371432', 'Wagner ThermoQuiet Ceramic Disc Brake Pad Set', 'Premium ceramic brake pads for reduced noise and dust', 'Wagner ThermoQuiet ceramic disc brake pad sets feature proprietary friction formulations that provide quiet operation and low dust. Engineered with Integrally Molded Insulator (IMI) technology that integrates the shim and pad into a single component.', true),
(2, 3, 2, 'ZD1433', '00810038371433', 'Wagner ThermoQuiet Ceramic Rear Brake Pad Set', 'Premium ceramic rear brake pads', 'High-performance ceramic compound rear brake pads with excellent stopping power and minimal brake dust.', true),
(3, 4, 2, 'EHT1432', '00078207914326', 'Raybestos Element3 EHT Brake Pads', 'Enhanced Hybrid Technology brake pads', 'Element3 EHT brake pads combine the best attributes of ceramic and semi-metallic friction technologies for superior performance.', true),
(4, 1, 2, '14D1432CH', '00036666314322', 'ACDelco Professional Ceramic Brake Pads', 'Professional grade ceramic brake pads', 'ACDelco Professional Ceramic Brake Pads are manufactured to meet expectations for fit, form, and function.', true),

-- Brake Rotors
(5, 3, 3, 'BD126333', '00810038126333', 'Wagner Premium E-Coated Brake Rotor', 'Premium coated brake rotor for corrosion resistance', 'Wagner Premium E-Coated rotors feature proprietary Electrophoretic coating that provides long-lasting corrosion protection.', true),
(6, 2, 3, '25010741', '00028851507413', 'Bosch QuietCast Premium Disc Brake Rotor', 'Premium disc brake rotor', 'Bosch QuietCast Premium Disc Brake Rotors are designed to deliver OE fit and function with reduced noise and vibration.', true),

-- Oil Filters
(7, 5, 6, 'PH9837', '00009100398370', 'FRAM Extra Guard Oil Filter', 'Premium engine oil filter', 'FRAM Extra Guard oil filters are engineered for conventional and synthetic motor oils providing proven protection for up to 10,000 miles.', true),
(8, 6, 6, '57356', '00765809573562', 'WIX Spin-On Oil Filter', 'High-efficiency oil filter', 'WIX oil filters feature a glass-enhanced media that provides superior engine protection.', true),
(9, 1, 6, 'PF63E', '00036666486636', 'ACDelco Professional Engine Oil Filter', 'Professional grade oil filter', 'ACDelco Professional Oil Filters are designed to trap particles that can cause engine damage.', true),

-- Air Filters
(10, 5, 7, 'CA11916', '00009100119161', 'FRAM Extra Guard Air Filter', 'Engine air filter for improved performance', 'FRAM Extra Guard Air Filters provide 2X the engine protection and help improve air flow and engine performance.', true),
(11, 6, 7, '46830', '00765809468305', 'WIX Panel Air Filter', 'High-efficiency engine air filter', 'WIX air filters protect your engine with high-efficiency filter media that traps harmful contaminants.', true),
(12, 2, 7, '5075WS', '00028851507512', 'Bosch Workshop Air Filter', 'Premium engine air filter', 'Bosch Workshop Air Filters provide superior filtration to protect your engine from harmful contaminants.', true),

-- Cabin Air Filters
(13, 5, 8, 'CF11173', '00009100111733', 'FRAM Fresh Breeze Cabin Air Filter', 'Cabin air filter with Arm & Hammer baking soda', 'FRAM Fresh Breeze Cabin Air Filters with Arm & Hammer baking soda naturally deodorize and freshen the air entering your vehicle.', true),
(14, 6, 8, '24815', '00765809248151', 'WIX Cabin Air Filter', 'Premium cabin air filter', 'WIX Cabin Air Filters trap pollen, dust, and other airborne contaminants to improve air quality inside your vehicle.', true),

-- Spark Plugs
(15, 7, 10, 'BKR5EYA', '00087295015056', 'NGK V-Power Spark Plug', 'Copper core spark plug', 'NGK V-Power spark plugs feature a unique v-cut center electrode that directs spark to the edge for better ignitability.', true),
(16, 7, 10, 'ILTR5A13G', '00087295091135', 'NGK Laser Iridium Spark Plug', 'Premium iridium spark plug', 'NGK Laser Iridium spark plugs provide superior ignitability and long service life with iridium center and ground electrodes.', true),
(17, 8, 10, '5344', '00037495053440', 'DENSO Iridium TT Spark Plug', 'Twin-tip iridium spark plug', 'DENSO Iridium TT features Twin-Tip technology with a 0.4mm iridium center electrode and 0.7mm needle ground electrode.', true),

-- Ignition Coils
(18, 8, 11, '6731301', '00037495673136', 'DENSO Direct Ignition Coil', 'OE quality ignition coil', 'DENSO Ignition Coils deliver optimal engine performance with OE quality and reliability.', true),
(19, 2, 11, '00148', '00028851001489', 'Bosch Ignition Coil', 'Premium ignition coil', 'Bosch Ignition Coils are designed to meet or exceed OE specifications for reliable performance.', true),

-- Shock Absorbers
(20, 9, 13, '32331', '00048598323310', 'Monroe OESpectrum Shock Absorber', 'Premium shock absorber', 'Monroe OESpectrum shocks feature Full Displaced Valving for smooth ride quality and excellent handling.', true),
(21, 10, 13, '344080', '00781552070806', 'KYB Excel-G Shock Absorber', 'Twin-tube shock absorber', 'KYB Excel-G shocks restore original equipment performance and handling with calibrated damping.', true),

-- Struts
(22, 9, 14, '171579', '00048598171579', 'Monroe Quick-Strut Complete Assembly', 'Complete strut assembly', 'Monroe Quick-Strut assemblies include all components required for strut replacement in a single, ready-to-install unit.', true),
(23, 10, 14, 'SR4033', '00781552040330', 'KYB Strut-Plus Complete Assembly', 'Complete strut assembly with spring', 'KYB Strut-Plus assemblies include new struts, coil springs, mounts, and protective boots.', true),

-- Control Arms
(24, 11, 15, 'RK620298', '00080066202980', 'Moog Control Arm Assembly', 'Premium control arm with ball joint', 'Moog Problem Solver control arms feature improved design and materials for extended service life.', true),
(25, 11, 15, 'RK620299', '00080066202997', 'Moog Front Lower Control Arm', 'Front lower control arm', 'Precision-engineered control arm with pre-installed ball joint for easy installation.', true),

-- Serpentine Belts
(26, 12, 17, 'K060815', '00076339008159', 'Gates Micro-V Serpentine Belt', 'Premium serpentine belt', 'Gates Micro-V belts feature advanced EPDM rubber compounds for superior performance and longer life.', true),
(27, 1, 17, '6K815', '00036666068151', 'ACDelco Professional V-Ribbed Belt', 'Professional grade serpentine belt', 'ACDelco Professional Serpentine Belts are manufactured to meet stringent quality standards.', true);

SELECT setval('pies.part_part_id_seq', 27, true);

-- Part Aliases (Common names in Spanish and colloquial terms)
INSERT INTO pies.part_alias (part_id, alias) VALUES
-- Brake pads aliases
(1, 'balatas delanteras'),
(1, 'pastillas de freno'),
(1, 'front brake pads'),
(2, 'balatas traseras'),
(2, 'rear brake pads'),
(3, 'balatas ceramicas'),
(4, 'balatas ACDelco'),
-- Brake rotors
(5, 'discos de freno'),
(5, 'rotores'),
(6, 'disco ventilado'),
-- Oil filters
(7, 'filtro de aceite'),
(7, 'oil filter FRAM'),
(8, 'filtro aceite WIX'),
(9, 'filtro motor'),
-- Air filters
(10, 'filtro de aire'),
(10, 'air cleaner'),
(11, 'filtro aire motor'),
-- Cabin filters
(13, 'filtro de cabina'),
(13, 'filtro aire acondicionado'),
(14, 'filtro polen'),
-- Spark plugs
(15, 'bujías NGK'),
(15, 'bujias'),
(16, 'bujías iridio'),
(17, 'bujías DENSO'),
-- Shocks
(20, 'amortiguadores'),
(20, 'shocks Monroe'),
(21, 'amortiguadores KYB'),
-- Struts
(22, 'struts completos'),
(22, 'puntales'),
(23, 'montaje puntal'),
-- Belts
(26, 'banda serpentina'),
(26, 'correa poly-v'),
(27, 'banda alternador');

-- Part Text (Multilingual descriptions and marketing copy)
INSERT INTO pies.part_text (part_id, lang, label, content) VALUES
-- English marketing copy
(1, 'en', 'marketing_copy', 'Experience whisper-quiet braking with Wagner ThermoQuiet ceramic brake pads. Engineered for luxury and performance vehicles.'),
(1, 'en', 'features', 'Ceramic formulation for quiet operation. Minimal brake dust. Extended pad life. Exceptional stopping power.'),
(1, 'en', 'bullets', '• One-piece design with integrated shim\n• Reduced noise and vibration\n• Low dust formula\n• Premium friction materials'),
(1, 'en', 'warranty', '12 months or 12,000 miles limited warranty'),

-- Spanish marketing copy
(1, 'es', 'marketing_copy', 'Experimente un frenado silencioso con las balatas cerámicas Wagner ThermoQuiet. Diseñadas para vehículos de lujo y alto rendimiento.'),
(1, 'es', 'features', 'Formulación cerámica para operación silenciosa. Mínimo polvo de freno. Vida útil extendida. Poder de frenado excepcional.'),
(1, 'es', 'bullets', '• Diseño de una pieza con calza integrada\n• Reducción de ruido y vibración\n• Fórmula de bajo polvo\n• Materiales de fricción premium'),
(1, 'es', 'warranty', 'Garantía limitada de 12 meses o 12,000 millas'),

-- Oil filter descriptions
(7, 'en', 'marketing_copy', 'FRAM Extra Guard oil filters deliver proven engine protection for all driving conditions.'),
(7, 'en', 'features', 'Engineered for conventional and synthetic oils. Dirt-trapping efficiency of 95%. Proven protection up to 10,000 miles.'),
(7, 'es', 'marketing_copy', 'Los filtros de aceite FRAM Extra Guard brindan protección comprobada del motor para todas las condiciones de manejo.'),
(7, 'es', 'features', 'Diseñado para aceites convencionales y sintéticos. Eficiencia de captura de suciedad del 95%. Protección comprobada hasta 10,000 millas.'),

-- Air filter descriptions
(10, 'en', 'marketing_copy', 'FRAM Extra Guard Air Filters provide 2X the engine protection to help improve air flow and engine performance.'),
(10, 'en', 'features', 'Traps harmful dirt and dust. Improves air flow for better acceleration. Easy to install.'),
(10, 'es', 'marketing_copy', 'Los filtros de aire FRAM Extra Guard proporcionan 2 veces la protección del motor para ayudar a mejorar el flujo de aire.'),
(10, 'es', 'features', 'Atrapa suciedad y polvo dañinos. Mejora el flujo de aire para mejor aceleración. Fácil de instalar.'),

-- Spark plug descriptions
(15, 'en', 'marketing_copy', 'NGK V-Power spark plugs deliver reliable performance with improved ignitability and fuel efficiency.'),
(15, 'en', 'features', 'V-cut center electrode. Superior anti-fouling. Corrugated ribs prevent flashover. Copper core for heat dissipation.'),
(15, 'es', 'marketing_copy', 'Las bujías NGK V-Power ofrecen rendimiento confiable con mejor ignición y eficiencia de combustible.'),
(15, 'es', 'features', 'Electrodo central en V. Anti-incrustación superior. Nervaduras corrugadas previenen descargas. Núcleo de cobre para disipación de calor.');

-- Part Attributes (Technical specifications)
INSERT INTO pies.part_attribute (part_id, attr_code, value_text, value_num, uom, lang) VALUES
-- Brake pad attributes
(1, 'PAD_MATERIAL', 'Ceramic', NULL, NULL, 'en'),
(1, 'POSITION', 'Front', NULL, NULL, 'en'),
(1, 'THICKNESS', NULL, 12.5, 'mm', NULL),
(1, 'QUANTITY', NULL, 4, 'pieces', NULL),
(2, 'PAD_MATERIAL', 'Ceramic', NULL, NULL, 'en'),
(2, 'POSITION', 'Rear', NULL, NULL, 'en'),
(2, 'THICKNESS', NULL, 10.0, 'mm', NULL),

-- Brake rotor attributes
(5, 'ROTOR_TYPE', 'Vented', NULL, NULL, 'en'),
(5, 'DIAMETER', NULL, 320, 'mm', NULL),
(5, 'THICKNESS', NULL, 32, 'mm', NULL),
(5, 'COATING', 'E-Coat', NULL, NULL, 'en'),

-- Oil filter attributes
(7, 'EFFICIENCY', NULL, 95, 'percent', NULL),
(7, 'BYPASS_VALVE', NULL, 12, 'psi', NULL),
(7, 'ANTI_DRAINBACK', 'Yes', NULL, NULL, 'en'),
(8, 'EFFICIENCY', NULL, 99, 'percent', NULL),
(8, 'THREAD_SIZE', 'M20x1.5', NULL, NULL, NULL),

-- Spark plug attributes
(15, 'THREAD_SIZE', 'M14x1.25', NULL, NULL, NULL),
(15, 'REACH', NULL, 19, 'mm', NULL),
(15, 'HEX_SIZE', NULL, 16, 'mm', NULL),
(15, 'GAP', NULL, 0.044, 'inch', NULL),
(16, 'ELECTRODE_TYPE', 'Iridium', NULL, NULL, 'en'),
(16, 'SERVICE_LIFE', NULL, 120000, 'miles', NULL),

-- Belt attributes
(26, 'LENGTH', NULL, 815, 'mm', NULL),
(26, 'RIBS', NULL, 6, 'count', NULL),
(26, 'MATERIAL', 'EPDM', NULL, NULL, 'en');

-- Part Interchanges (Cross-references between brands)
INSERT INTO pies.part_interchange (part_id, xref_brand, xref_mpn, notes) VALUES
-- Wagner brake pads cross-reference
(1, 'Raybestos', 'EHT1432', 'Direct replacement'),
(1, 'ACDelco', '14D1432CH', 'Professional equivalent'),
(1, 'Bosch', 'BC1432', 'OE replacement'),
-- Raybestos cross to Wagner
(3, 'Wagner', 'ZD1432', 'Direct replacement'),
(3, 'ACDelco', '14D1432CH', 'Compatible'),
-- FRAM oil filter crosses
(7, 'WIX', '57356', 'Direct replacement'),
(7, 'ACDelco', 'PF63E', 'Compatible'),
(7, 'Purolator', 'L14612', 'Alternative'),
-- WIX crosses
(8, 'FRAM', 'PH9837', 'Direct replacement'),
(8, 'Motorcraft', 'FL-500S', 'OE equivalent'),
-- NGK spark plug crosses
(15, 'DENSO', 'K20R-U', 'Direct replacement'),
(15, 'Champion', 'RC12YC', 'Alternative'),
(16, 'DENSO', '5344', 'Iridium equivalent');

-- Part Assets (Images, PDFs, etc.)
INSERT INTO pies.part_asset (part_id, asset_type, uri, sort_order, alt_text, lang) VALUES
-- Brake pad images
(1, 'image', 'https://cdn.example.com/wagner/zd1432_main.jpg', 1, 'Wagner ThermoQuiet Ceramic Brake Pads', 'en'),
(1, 'image', 'https://cdn.example.com/wagner/zd1432_installed.jpg', 2, 'Wagner brake pads installed view', 'en'),
(1, 'pdf', 'https://cdn.example.com/wagner/zd1432_install.pdf', 3, 'Installation instructions', 'en'),
(1, 'pdf', 'https://cdn.example.com/wagner/zd1432_install_es.pdf', 4, 'Instrucciones de instalación', 'es'),
-- Oil filter images
(7, 'image', 'https://cdn.example.com/fram/ph9837_main.jpg', 1, 'FRAM Extra Guard Oil Filter', 'en'),
(7, 'pdf', 'https://cdn.example.com/fram/ph9837_specs.pdf', 2, 'Technical specifications', 'en'),
-- Spark plug images
(15, 'image', 'https://cdn.example.com/ngk/bkr5eya_main.jpg', 1, 'NGK V-Power Spark Plug', 'en'),
(15, 'video', 'https://cdn.example.com/ngk/install_guide.mp4', 2, 'Installation video guide', 'en');

-- Part Packaging Information
INSERT INTO pies.part_package (part_id, package_level, qty, uom_qty, dim_l, dim_w, dim_h, dim_uom, weight, weight_uom, gtin) VALUES
-- Brake pad packaging
(1, 'each', 1, 'set', 250, 180, 65, 'mm', 2.3, 'kg', '00810038371432'),
(1, 'case', 4, 'sets', 530, 380, 140, 'mm', 10.2, 'kg', '10810038371439'),
-- Oil filter packaging
(7, 'each', 1, 'piece', 85, 85, 120, 'mm', 0.35, 'kg', '00009100398370'),
(7, 'case', 12, 'pieces', 270, 270, 130, 'mm', 4.5, 'kg', '10009100398377'),
-- Spark plug packaging
(15, 'each', 1, 'piece', 22, 22, 100, 'mm', 0.05, 'kg', '00087295015056'),
(15, 'inner', 4, 'pieces', 90, 45, 105, 'mm', 0.22, 'kg', '10087295015053'),
(15, 'case', 40, 'pieces', 280, 190, 110, 'mm', 2.3, 'kg', '20087295015050');

-- =====================================================================
-- ACES DATA
-- =====================================================================

-- =====================================================================
-- STEP 3: Insert ACES data (reference tables first)  
-- =====================================================================

-- Vehicle Makes
INSERT INTO aces.vehicle_make (make_id, name, country) VALUES
(1, 'Toyota', 'Japan'),
(2, 'Honda', 'Japan'),
(3, 'Ford', 'USA'),
(4, 'Chevrolet', 'USA'),
(5, 'Nissan', 'Japan'),
(6, 'Volkswagen', 'Germany'),
(7, 'BMW', 'Germany'),
(8, 'Mercedes-Benz', 'Germany'),
(9, 'Mazda', 'Japan'),
(10, 'Hyundai', 'South Korea'),
(11, 'Kia', 'South Korea'),
(12, 'Jeep', 'USA');

SELECT setval('aces.vehicle_make_make_id_seq', 12, true);

-- Vehicle Models
INSERT INTO aces.vehicle_model (model_id, make_id, name) VALUES
-- Toyota
(1, 1, 'Camry'),
(2, 1, 'Corolla'),
(3, 1, 'RAV4'),
(4, 1, 'Tacoma'),
(5, 1, 'Highlander'),
-- Honda
(6, 2, 'Accord'),
(7, 2, 'Civic'),
(8, 2, 'CR-V'),
(9, 2, 'Pilot'),
-- Ford
(10, 3, 'F-150'),
(11, 3, 'Escape'),
(12, 3, 'Explorer'),
(13, 3, 'Mustang'),
-- Chevrolet
(14, 4, 'Silverado 1500'),
(15, 4, 'Malibu'),
(16, 4, 'Equinox'),
(17, 4, 'Tahoe'),
-- Nissan
(18, 5, 'Altima'),
(19, 5, 'Sentra'),
(20, 5, 'Rogue'),
-- VW
(21, 6, 'Jetta'),
(22, 6, 'Tiguan'),
(23, 6, 'Golf'),
-- BMW
(24, 7, '3 Series'),
(25, 7, 'X3'),
(26, 7, 'X5');

SELECT setval('aces.vehicle_model_model_id_seq', 26, true);

-- Vehicle Submodels
INSERT INTO aces.vehicle_submodel (submodel_id, model_id, name) VALUES
-- Toyota Camry
(1, 1, 'LE'),
(2, 1, 'SE'),
(3, 1, 'XLE'),
(4, 1, 'XSE'),
(5, 1, 'TRD'),
-- Honda Accord
(6, 6, 'LX'),
(7, 6, 'Sport'),
(8, 6, 'EX'),
(9, 6, 'EX-L'),
(10, 6, 'Touring'),
-- Ford F-150
(11, 10, 'Regular Cab'),
(12, 10, 'SuperCab'),
(13, 10, 'SuperCrew'),
(14, 10, 'Raptor'),
-- Chevy Silverado
(15, 14, 'WT'),
(16, 14, 'LT'),
(17, 14, 'RST'),
(18, 14, 'LTZ'),
(19, 14, 'High Country'),
-- BMW 3 Series
(20, 24, '330i'),
(21, 24, '330i xDrive'),
(22, 24, 'M340i'),
(23, 24, 'M340i xDrive');

SELECT setval('aces.vehicle_submodel_submodel_id_seq', 23, true);

-- Engines
INSERT INTO aces.engine (engine_id, cylinders, displacement_cc, fuel_type, aspiration, vin_code) VALUES
(1, 4, 2500, 'Gasoline', 'NA', 'A'),  -- 2.5L I4
(2, 6, 3500, 'Gasoline', 'NA', 'G'),  -- 3.5L V6
(3, 4, 2000, 'Gasoline', 'Turbo', 'L'), -- 2.0L Turbo I4
(4, 4, 1500, 'Gasoline', 'Turbo', 'B'), -- 1.5L Turbo I4
(5, 8, 5300, 'Gasoline', 'NA', 'L'),  -- 5.3L V8
(6, 8, 6200, 'Gasoline', 'NA', 'J'),  -- 6.2L V8
(7, 4, 2400, 'Gasoline', 'NA', 'K'),  -- 2.4L I4
(8, 4, 1800, 'Gasoline', 'NA', 'R'),  -- 1.8L I4
(9, 6, 3600, 'Gasoline', 'NA', '3'),  -- 3.6L V6
(10, 4, 2700, 'Gasoline', 'Turbo', 'T'), -- 2.7L Turbo I4
(11, 6, 3000, 'Gasoline', 'Turbo', 'B'), -- 3.0L Turbo I6
(12, 6, 3300, 'Diesel', 'Turbo', 'D'); -- 3.3L Turbo Diesel

SELECT setval('aces.engine_engine_id_seq', 12, true);

-- Transmissions
INSERT INTO aces.transmission (transmission_id, type, speeds) VALUES
(1, 'AT', 8),   -- 8-speed automatic
(2, 'AT', 10),  -- 10-speed automatic
(3, 'CVT', NULL), -- CVT
(4, 'MT', 6),   -- 6-speed manual
(5, 'AT', 9),   -- 9-speed automatic
(6, 'DCT', 7),  -- 7-speed dual clutch
(7, 'AT', 6);   -- 6-speed automatic

SELECT setval('aces.transmission_transmission_id_seq', 7, true);

-- Position References
INSERT INTO aces.position_ref (position_id, code, name) VALUES
(1, 'FRONT', 'Front'),
(2, 'REAR', 'Rear'),
(3, 'FRONT_LEFT', 'Front Left'),
(4, 'FRONT_RIGHT', 'Front Right'),
(5, 'REAR_LEFT', 'Rear Left'),
(6, 'REAR_RIGHT', 'Rear Right'),
(7, 'ALL', 'All Positions'),
(8, 'DRIVER', 'Driver Side'),
(9, 'PASSENGER', 'Passenger Side');

SELECT setval('aces.position_ref_position_id_seq', 9, true);

-- Qualifier References
INSERT INTO aces.qualifier_ref (qualifier_id, code, description) VALUES
(1, 'WITH_ABS', 'With Anti-lock Braking System'),
(2, 'WITHOUT_ABS', 'Without Anti-lock Braking System'),
(3, 'HEAVY_DUTY', 'Heavy Duty Package'),
(4, 'POLICE_PKG', 'Police Package'),
(5, 'SPORT_PKG', 'Sport Package'),
(6, 'TOWING_PKG', 'Towing Package'),
(7, 'CALIFORNIA_EMISSIONS', 'California Emissions'),
(8, 'FEDERAL_EMISSIONS', 'Federal Emissions'),
(9, 'TURBO', 'Turbocharged'),
(10, 'PERFORMANCE_BRAKES', 'Performance Brake Package');

SELECT setval('aces.qualifier_ref_qualifier_id_seq', 10, true);

-- Fitment Applications (Connecting parts to vehicles)
INSERT INTO aces.fitment_application (application_id, part_id, year_start, year_end, make_id, model_id, submodel_id, engine_id, transmission_id, position_id, notes) VALUES
-- Wagner brake pads fit multiple vehicles
-- Toyota Camry 2018-2023
(1, 1, 2018, 2023, 1, 1, 1, 1, 1, 1, 'Front brake pads for Camry LE with 2.5L engine'),
(2, 1, 2018, 2023, 1, 1, 2, 1, 1, 1, 'Front brake pads for Camry SE with 2.5L engine'),
(3, 1, 2018, 2023, 1, 1, 3, 2, 1, 1, 'Front brake pads for Camry XLE with 3.5L V6'),
(4, 2, 2018, 2023, 1, 1, NULL, NULL, NULL, 2, 'Rear brake pads for all Camry models'),

-- Honda Accord 2018-2022
(5, 1, 2018, 2022, 2, 6, 6, 4, 3, 1, 'Front brake pads for Accord LX 1.5T'),
(6, 1, 2018, 2022, 2, 6, 7, 4, 3, 1, 'Front brake pads for Accord Sport 1.5T'),
(7, 1, 2018, 2022, 2, 6, 8, 3, 2, 1, 'Front brake pads for Accord EX 2.0T'),
(8, 2, 2018, 2022, 2, 6, NULL, NULL, NULL, 2, 'Rear brake pads for all Accord models'),

-- Raybestos pads
(9, 3, 2019, 2024, 3, 10, 13, 5, 2, 1, 'Front pads for F-150 SuperCrew 5.3L'),
(10, 3, 2019, 2024, 3, 10, 14, 6, 2, 1, 'Front pads for F-150 Raptor 6.2L'),

-- ACDelco pads
(11, 4, 2019, 2023, 4, 14, 16, 5, 1, 1, 'Front pads for Silverado LT 5.3L'),
(12, 4, 2019, 2023, 4, 14, 19, 6, 2, 1, 'Front pads for Silverado High Country 6.2L'),

-- Wagner brake rotor applications
(13, 5, 2018, 2023, 1, 1, NULL, NULL, NULL, 1, 'Front rotor for Toyota Camry all models'),
(14, 5, 2018, 2022, 2, 6, NULL, NULL, NULL, 1, 'Front rotor for Honda Accord all models'),

-- Bosch rotor
(15, 6, 2019, 2024, 3, 10, NULL, NULL, NULL, 1, 'Front rotor for Ford F-150 all models'),

-- Oil filter applications - FRAM
(16, 7, 2016, 2023, 1, 2, NULL, 8, NULL, NULL, 'Oil filter for Corolla 1.8L'),
(17, 7, 2017, 2024, 1, 3, NULL, 1, NULL, NULL, 'Oil filter for RAV4 2.5L'),
(18, 7, 2018, 2023, 1, 1, NULL, 1, NULL, NULL, 'Oil filter for Camry 2.5L'),

-- Oil filter - WIX
(19, 8, 2019, 2024, 3, 10, NULL, 5, NULL, NULL, 'Oil filter for F-150 5.3L V8'),
(20, 8, 2019, 2024, 3, 10, NULL, 10, NULL, NULL, 'Oil filter for F-150 2.7L EcoBoost'),

-- Oil filter - ACDelco
(21, 9, 2019, 2023, 4, 14, NULL, 5, NULL, NULL, 'Oil filter for Silverado 5.3L'),
(22, 9, 2019, 2023, 4, 17, NULL, 5, NULL, NULL, 'Oil filter for Tahoe 5.3L'),

-- Air filter applications - FRAM
(23, 10, 2018, 2023, 1, 1, NULL, 1, NULL, NULL, 'Engine air filter for Camry 2.5L'),
(24, 10, 2018, 2023, 1, 1, NULL, 2, NULL, NULL, 'Engine air filter for Camry 3.5L V6'),

-- Air filter - WIX
(25, 11, 2018, 2022, 2, 6, NULL, 4, NULL, NULL, 'Engine air filter for Accord 1.5T'),
(26, 11, 2018, 2022, 2, 7, NULL, 4, NULL, NULL, 'Engine air filter for Civic 1.5T'),

-- Air filter - Bosch
(27, 12, 2018, 2022, 6, 21, NULL, 3, NULL, NULL, 'Engine air filter for Jetta 2.0T'),
(28, 12, 2018, 2022, 6, 23, NULL, 3, NULL, NULL, 'Engine air filter for Golf 2.0T'),

-- Cabin air filter - FRAM Fresh Breeze
(29, 13, 2018, 2023, 1, 1, NULL, NULL, NULL, NULL, 'Cabin air filter for all Camry models'),
(30, 13, 2017, 2024, 1, 3, NULL, NULL, NULL, NULL, 'Cabin air filter for all RAV4 models'),
(31, 13, 2018, 2023, 1, 5, NULL, NULL, NULL, NULL, 'Cabin air filter for all Highlander models'),

-- Cabin air filter - WIX
(32, 14, 2018, 2022, 2, 6, NULL, NULL, NULL, NULL, 'Cabin air filter for all Accord models'),
(33, 14, 2018, 2024, 2, 8, NULL, NULL, NULL, NULL, 'Cabin air filter for all CR-V models'),

-- Spark plugs - NGK V-Power
(34, 15, 2013, 2018, 1, 2, NULL, 8, NULL, NULL, 'Spark plugs for Corolla 1.8L'),
(35, 15, 2015, 2020, 5, 19, NULL, 8, NULL, NULL, 'Spark plugs for Sentra 1.8L'),

-- NGK Laser Iridium
(36, 16, 2018, 2023, 1, 1, NULL, 2, NULL, NULL, 'Iridium plugs for Camry 3.5L V6'),
(37, 16, 2019, 2024, 2, 9, NULL, 9, NULL, NULL, 'Iridium plugs for Pilot 3.6L V6'),

-- DENSO Iridium TT
(38, 17, 2017, 2022, 7, 24, 20, 11, NULL, NULL, 'Iridium plugs for BMW 330i 3.0L turbo'),
(39, 17, 2017, 2022, 7, 24, 22, 11, NULL, NULL, 'Iridium plugs for BMW M340i 3.0L turbo'),

-- Ignition coils - DENSO
(40, 18, 2018, 2023, 1, 1, NULL, 1, NULL, NULL, 'Ignition coils for Camry 2.5L'),
(41, 18, 2017, 2024, 1, 3, NULL, 1, NULL, NULL, 'Ignition coils for RAV4 2.5L'),

-- Bosch ignition coil
(42, 19, 2015, 2022, 6, 21, NULL, 3, NULL, NULL, 'Ignition coil for Jetta 2.0T'),

-- Shock absorbers - Monroe
(43, 20, 2015, 2020, 1, 2, NULL, NULL, NULL, 2, 'Rear shocks for Corolla all models'),
(44, 20, 2016, 2021, 2, 7, NULL, NULL, NULL, 2, 'Rear shocks for Civic all models'),

-- KYB shocks
(45, 21, 2018, 2024, 1, 4, NULL, NULL, NULL, 2, 'Rear shocks for Tacoma all models'),
(46, 21, 2019, 2024, 3, 10, NULL, NULL, NULL, 2, 'Rear shocks for F-150 all models'),

-- Struts - Monroe Quick-Strut
(47, 22, 2018, 2023, 1, 1, NULL, NULL, NULL, 1, 'Front strut assembly for Camry all models'),
(48, 22, 2018, 2022, 2, 6, NULL, NULL, NULL, 1, 'Front strut assembly for Accord all models'),

-- KYB Strut-Plus
(49, 23, 2017, 2024, 1, 3, NULL, NULL, NULL, 1, 'Front strut assembly for RAV4 all models'),
(50, 23, 2018, 2024, 2, 8, NULL, NULL, NULL, 1, 'Front strut assembly for CR-V all models'),

-- Control arms - Moog
(51, 24, 2019, 2024, 3, 10, NULL, NULL, NULL, 3, 'Front left control arm for F-150'),
(52, 25, 2019, 2024, 3, 10, NULL, NULL, NULL, 4, 'Front right control arm for F-150'),

-- Serpentine belts - Gates
(53, 26, 2018, 2023, 1, 1, NULL, 1, NULL, NULL, '6-rib belt for Camry 2.5L'),
(54, 26, 2019, 2024, 3, 10, NULL, 5, NULL, NULL, '6-rib belt for F-150 5.3L'),

-- ACDelco belt
(55, 27, 2019, 2023, 4, 14, NULL, 5, NULL, NULL, '6-rib belt for Silverado 5.3L');

SELECT setval('aces.fitment_application_application_id_seq', 55, true);

-- Fitment Application Qualifiers
INSERT INTO aces.fitment_application_qualifier (application_id, qualifier_id, value_text) VALUES
-- Camry with ABS
(1, 1, 'Standard'),
(2, 1, 'Standard'),
(3, 1, 'Standard'),
-- F-150 Heavy Duty
(9, 3, 'Optional'),
(10, 3, 'Standard'),
-- F-150 Towing Package
(9, 6, 'Optional'),
(10, 6, 'Standard on Raptor'),
-- Performance brakes on BMW
(38, 10, 'M Sport Brakes'),
(39, 10, 'M Performance Brakes'),
-- California emissions
(16, 7, 'CARB Compliant'),
(23, 7, 'CARB Compliant'),
-- Turbo engines
(7, 9, '2.0L Turbo'),
(27, 9, '2.0L TSI'),
(38, 9, 'TwinPower Turbo');

-- =====================================================================
-- STEP 4: Populate Search Rollups  
-- =====================================================================

-- First ensure all parts have normalized text and FTS vectors
-- This triggers normalization and FTS vector generation
UPDATE pies.part SET display_name = display_name WHERE part_id > 0;
UPDATE pies.part_alias SET alias = alias WHERE alias_id > 0;

-- Create rollup entries for all parts
INSERT INTO pies.part_search_rollup (part_id) 
SELECT part_id FROM pies.part 
ON CONFLICT (part_id) DO NOTHING;

-- Refresh all rollups to aggregate aliases and marketing text
DO $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT part_id FROM pies.part LOOP
    PERFORM pies.part_search_rollup_refresh(r.part_id);
  END LOOP;
END$$;

-- =====================================================================
-- STEP 5: Verify Data Load and Commit
-- =====================================================================

-- Summary statistics
DO $$
DECLARE
  v_brands INTEGER;
  v_parts INTEGER;
  v_vehicles INTEGER;
  v_applications INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_brands FROM pies.brand;
  SELECT COUNT(*) INTO v_parts FROM pies.part;
  SELECT COUNT(DISTINCT make_id || '-' || model_id) INTO v_vehicles FROM aces.vehicle_model;
  SELECT COUNT(*) INTO v_applications FROM aces.fitment_application;
  
  RAISE NOTICE '======================================';
  RAISE NOTICE 'Synthetic Data Load Summary:';
  RAISE NOTICE '======================================';
  RAISE NOTICE '  Brands loaded: %', v_brands;
  RAISE NOTICE '  Parts loaded: %', v_parts;
  RAISE NOTICE '  Vehicle Models loaded: %', v_vehicles;
  RAISE NOTICE '  Fitment Applications loaded: %', v_applications;
  RAISE NOTICE '======================================';
  RAISE NOTICE 'Transaction will be committed.';
END$$;

-- Commit the transaction
COMMIT;

-- =====================================================================
-- Sample Verification Queries (run these after data load)
-- =====================================================================

DO $$
BEGIN
    -- Only run verification queries if tables exist and have data
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'pies' AND table_name = 'part') AND
       EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'aces' AND table_name = 'fitment_application') THEN
        
        RAISE NOTICE '';
        RAISE NOTICE 'Sample verification queries:';
        RAISE NOTICE '==============================';
        
        -- Show sample fitment
        RAISE NOTICE '';
        RAISE NOTICE '%', 'To find parts for a specific vehicle, run:';
        RAISE NOTICE '%', 'SELECT p.display_name, b.name FROM aces.fitment_application fa';
        RAISE NOTICE '%', 'JOIN pies.part p ON p.part_id = fa.part_id';
        RAISE NOTICE '%', 'JOIN pies.brand b ON b.brand_id = p.brand_id';
        RAISE NOTICE '%', 'JOIN aces.vehicle_make mk ON mk.make_id = fa.make_id';
        RAISE NOTICE '%', 'WHERE mk.name = ''Toyota'' AND 2020 BETWEEN fa.year_start AND fa.year_end;';

        -- Show sample search
        RAISE NOTICE '';
        RAISE NOTICE '%', 'To search parts by Spanish term, run:';
        RAISE NOTICE '%', 'SELECT p.display_name FROM pies.part p';
        RAISE NOTICE '%', 'JOIN pies.part_alias pa ON pa.part_id = p.part_id';
        RAISE NOTICE '%', 'WHERE pa.alias_norm ILIKE ''%balata%'';';

    END IF;
END $$;

-- Display final message
DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '✓ Synthetic data load completed successfully!';
    RAISE NOTICE 'Run test_synthetic.sql to verify the data.';
END $$;
