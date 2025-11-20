#!/bin/bash
# Script: compare_schemas.sh
# Purpose: Compare database schemas between TEST and STAGE environments

set -e

echo "========================================="
echo "  DATABASE SCHEMA COMPARISON"
echo "========================================="
echo ""

# Configuration
TEST_DB="alpine_tracker"
STAGE_DB="alpine_tracker_stage"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="./schema_reports"
mkdir -p $REPORT_DIR

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Step 1: Exporting TEST schema..."
docker exec alpine_postgres_stage pg_dump -U postgres \
    --schema-only \
    --no-owner \
    --no-privileges \
    $TEST_DB > $REPORT_DIR/test_schema_${TIMESTAMP}.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ TEST schema exported${NC}"
else
    echo -e "${RED}✗ Failed to export TEST schema${NC}"
    exit 1
fi

echo ""
echo "Step 2: Exporting STAGE schema..."
docker exec alpine_postgres_stage pg_dump -U postgres \
    --schema-only \
    --no-owner \
    --no-privileges \
    $STAGE_DB > $REPORT_DIR/stage_schema_${TIMESTAMP}.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ STAGE schema exported${NC}"
else
    echo -e "${RED}✗ Failed to export STAGE schema${NC}"
    exit 1
fi

echo ""
echo "Step 3: Comparing schemas..."

# Remove timestamps and auto-generated comments for clean diff
sed -i '/^--/d' $REPORT_DIR/test_schema_${TIMESTAMP}.sql
sed -i '/^--/d' $REPORT_DIR/stage_schema_${TIMESTAMP}.sql

# Compare
diff -u $REPORT_DIR/stage_schema_${TIMESTAMP}.sql \
        $REPORT_DIR/test_schema_${TIMESTAMP}.sql \
        > $REPORT_DIR/schema_diff_${TIMESTAMP}.txt || true

if [ -s $REPORT_DIR/schema_diff_${TIMESTAMP}.txt ]; then
    echo -e "${YELLOW}⚠ Schema differences detected!${NC}"
    echo ""
    echo "Differences:"
    cat $REPORT_DIR/schema_diff_${TIMESTAMP}.txt | head -50
    echo ""
    echo "Full diff saved to: $REPORT_DIR/schema_diff_${TIMESTAMP}.txt"
    echo ""
    echo -e "${YELLOW}STAGE schema needs update${NC}"
    exit 2  # Exit code 2 = differences found
else
    echo -e "${GREEN}✓ Schemas are identical${NC}"
    echo ""
    echo "No migration needed - STAGE is up to date"
    exit 0  # Exit code 0 = no differences
fi
