#!/bin/bash
# =====================================================================
# Load Synthetic Data into AutoFit Catalog Database
# =====================================================================
# This script loads the synthetic test data into the database.
# It handles database connection and provides clear feedback.

# Configuration (modify as needed)
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="autofit_catalog_db"
DB_USER="autofit_owner"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}AutoFit Catalog - Synthetic Data Loader${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo -e "${RED}Error: psql command not found. Please install PostgreSQL client.${NC}"
    exit 1
fi

# Check if synthetic_data.sql exists
if [ ! -f "synthetic_data.sql" ]; then
    echo -e "${RED}Error: synthetic_data.sql not found in current directory.${NC}"
    echo "Please run this script from the database/queries directory."
    exit 1
fi

echo "Database Configuration:"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo ""

# Prompt for password
echo -n "Enter password for $DB_USER: "
read -s DB_PASSWORD
echo ""
echo ""

# Set PGPASSWORD environment variable for this session
export PGPASSWORD=$DB_PASSWORD

echo -e "${YELLOW}Loading synthetic data...${NC}"
echo "This will:"
echo "  1. Clear existing catalog data"
echo "  2. Load sample brands, parts, and vehicles"
echo "  3. Create fitment applications"
echo "  4. Build search indexes"
echo ""

# Execute the SQL script
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f synthetic_data.sql

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Synthetic data loaded successfully!${NC}"
    echo ""
    echo "You can now test the catalog with queries like:"
    echo ""
    echo "  -- Find parts for a specific vehicle:"
    echo "  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \\"
    echo "    \"SELECT p.display_name, b.name as brand"
    echo "     FROM aces.fitment_application fa"
    echo "     JOIN pies.part p ON p.part_id = fa.part_id"
    echo "     JOIN pies.brand b ON b.brand_id = p.brand_id"
    echo "     JOIN aces.vehicle_make mk ON mk.make_id = fa.make_id"
    echo "     JOIN aces.vehicle_model m ON m.model_id = fa.model_id"
    echo "     WHERE mk.name = 'Toyota' AND m.name = 'Camry'"
    echo "     AND 2020 BETWEEN fa.year_start AND fa.year_end"
    echo "     LIMIT 5;\""
    echo ""
    echo "  -- Search for parts by name:"
    echo "  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \\"
    echo "    \"SELECT display_name, mpn FROM pies.part"
    echo "     WHERE name_normalized ILIKE '%brake%' LIMIT 5;\""
else
    echo ""
    echo -e "${RED}✗ Error loading synthetic data.${NC}"
    echo "Please check the error messages above and ensure:"
    echo "  1. The database exists and is running"
    echo "  2. The schema.sql has been applied first"
    echo "  3. The credentials are correct"
    exit 1
fi

# Clean up
unset PGPASSWORD
