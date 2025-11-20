#!/bin/bash
# Script: cicd_db_migration.sh
# Purpose: Main CI/CD script for database migration with schema comparison
# Usage: Called by TeamCity for DEV branch

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  CI/CD DATABASE MIGRATION PIPELINE${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo "Branch: DEV"
echo "Target: STAGE environment"
echo "Date: $(date)"
echo ""

# Step 1: Compare schemas
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}STEP 1: Schema Comparison${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

./scripts/compare_schemas.sh
COMPARE_RESULT=$?

echo ""

# Handle comparison result
if [ $COMPARE_RESULT -eq 0 ]; then
    echo -e "${GREEN}✓ RESULT: Schemas are identical${NC}"
    echo -e "${GREEN}✓ ACTION: No migration needed${NC}"
    echo ""
    echo "STAGE database is already up to date."
    exit 0
    
elif [ $COMPARE_RESULT -eq 2 ]; then
    echo -e "${YELLOW}⚠ RESULT: Schema differences detected${NC}"
    echo -e "${YELLOW}⚠ ACTION: Migration required${NC}"
    echo ""
    
    # Step 2: Deploy to STAGE
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}STEP 2: Deploy to STAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    ./scripts/deploy_to_stage.sh
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓✓✓ DEPLOYMENT SUCCESSFUL ✓✓✓${NC}"
        echo ""
        
        # Step 3: Verify schemas match after migration
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}STEP 3: Post-deployment Verification${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        
        ./scripts/compare_schemas.sh
        VERIFY_RESULT=$?
        
        if [ $VERIFY_RESULT -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✓ VERIFIED: STAGE and TEST schemas are now synchronized${NC}"
            exit 0
        else
            echo ""
            echo -e "${YELLOW}⚠ WARNING: Schemas still differ after migration${NC}"
            exit 3
        fi
    else
        echo ""
        echo -e "${RED}✗✗✗ DEPLOYMENT FAILED ✗✗✗${NC}"
        exit 1
    fi
    
else
    echo -e "${RED}✗ RESULT: Schema comparison error${NC}"
    exit 1
fi
