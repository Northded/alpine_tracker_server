#!/bin/bash
# Script: deploy_to_stage.sh
# Purpose: Deploy database migrations to STAGE environment

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}  STAGE DATABASE DEPLOYMENT${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""

# Configuration
STAGE_DB="alpine_tracker_stage"
BACKUP_DIR="./db_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Activate virtual environment
echo "Step 1: Activating virtual environment..."
source venv/bin/activate
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Virtual environment activated${NC}"
else
    echo -e "${RED}✗ Failed to activate venv${NC}"
    exit 1
fi

echo ""
echo "Step 2: Backup STAGE database..."
docker exec alpine_postgres_stage pg_dump -U postgres \
    $STAGE_DB > $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup created: $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql${NC}"
else
    echo -e "${RED}✗ Backup failed${NC}"
    exit 1
fi

echo ""
echo "Step 3: Checking current Alembic version..."
# Set database URL for STAGE
export DATABASE_URL="postgresql://postgres:5428@localhost:5432/$STAGE_DB"

CURRENT_VERSION=$(alembic -x db=$STAGE_DB current 2>&1 | grep -oP '[a-f0-9]{12}' | head -1)
echo "Current STAGE version: ${CURRENT_VERSION:-none}"

echo ""
echo "Step 4: Applying migrations to STAGE..."
alembic -x db=$STAGE_DB upgrade head

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Migrations applied successfully${NC}"
else
    echo -e "${RED}✗ Migration failed - Rolling back...${NC}"
    
    # Restore from backup
    echo "Restoring from backup..."
    docker exec -i alpine_postgres_stage psql -U postgres $STAGE_DB < $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql
    
    exit 1
fi

echo ""
echo "Step 5: Verifying migration..."
NEW_VERSION=$(alembic -x db=$STAGE_DB current 2>&1 | grep -oP '[a-f0-9]{12}' | head -1)
echo "New STAGE version: $NEW_VERSION"

echo ""
echo "Step 6: Testing STAGE database..."
docker exec alpine_postgres_stage psql -U postgres $STAGE_DB <<EOF
-- Quick validation
SELECT 'mountains' as table_name, COUNT(*) as records FROM mountains
UNION ALL
SELECT 'equipment', COUNT(*) FROM equipment;

-- Check new fields
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'mountains' 
AND column_name = 'created_at';
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ STAGE database validation passed${NC}"
else
    echo -e "${YELLOW}⚠ STAGE validation warnings${NC}"
fi

echo ""
echo -e "${CYAN}=========================================${NC}"
echo -e "${GREEN}  DEPLOYMENT COMPLETED SUCCESSFULLY${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo "Summary:"
echo "  - Backup: $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql"
echo "  - Previous version: ${CURRENT_VERSION:-none}"
echo "  - New version: $NEW_VERSION"
echo ""
1~#!/bin/bash
# Script: deploy_to_stage.sh
# Purpose: Deploy database migrations to STAGE environment

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=========================================${NC}"
echo -e "${CYAN}  STAGE DATABASE DEPLOYMENT${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""

# Configuration
STAGE_DB="alpine_tracker_stage"
BACKUP_DIR="./db_backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Activate virtual environment
echo "Step 1: Activating virtual environment..."
source venv/bin/activate
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Virtual environment activated${NC}"
else
    echo -e "${RED}✗ Failed to activate venv${NC}"
    exit 1
fi

echo ""
echo "Step 2: Backup STAGE database..."
docker exec alpine_postgres_stage pg_dump -U postgres \
    $STAGE_DB > $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backup created: $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql${NC}"
else
    echo -e "${RED}✗ Backup failed${NC}"
    exit 1
fi

echo ""
echo "Step 3: Checking current Alembic version..."
# Set database URL for STAGE
export DATABASE_URL="postgresql://postgres:5428@localhost:5432/$STAGE_DB"

CURRENT_VERSION=$(alembic -x db=$STAGE_DB current 2>&1 | grep -oP '[a-f0-9]{12}' | head -1)
echo "Current STAGE version: ${CURRENT_VERSION:-none}"

echo ""
echo "Step 4: Applying migrations to STAGE..."
alembic -x db=$STAGE_DB upgrade head

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Migrations applied successfully${NC}"
else
    echo -e "${RED}✗ Migration failed - Rolling back...${NC}"
    
    # Restore from backup
    echo "Restoring from backup..."
    docker exec -i alpine_postgres_stage psql -U postgres $STAGE_DB < $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql
    
    exit 1
fi

echo ""
echo "Step 5: Verifying migration..."
NEW_VERSION=$(alembic -x db=$STAGE_DB current 2>&1 | grep -oP '[a-f0-9]{12}' | head -1)
echo "New STAGE version: $NEW_VERSION"

echo ""
echo "Step 6: Testing STAGE database..."
docker exec alpine_postgres_stage psql -U postgres $STAGE_DB <<EOF
-- Quick validation
SELECT 'mountains' as table_name, COUNT(*) as records FROM mountains
UNION ALL
SELECT 'equipment', COUNT(*) FROM equipment;

-- Check new fields
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'mountains' 
AND column_name = 'created_at';
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ STAGE database validation passed${NC}"
else
    echo -e "${YELLOW}⚠ STAGE validation warnings${NC}"
fi

echo ""
echo -e "${CYAN}=========================================${NC}"
echo -e "${GREEN}  DEPLOYMENT COMPLETED SUCCESSFULLY${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo "Summary:"
echo "  - Backup: $BACKUP_DIR/stage_backup_${TIMESTAMP}.sql"
echo "  - Previous version: ${CURRENT_VERSION:-none}"
echo "  - New version: $NEW_VERSION"
echo ""
