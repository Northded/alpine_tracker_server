-- STAGE Migration: Lab 8 Task 6
-- Date: 2025-11-20
-- Description: Add created_at to Mountain and Equipment table

BEGIN;

ALTER TABLE mountains 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

CREATE TABLE IF NOT EXISTS equipment (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    equipment_type VARCHAR NOT NULL,
    condition VARCHAR,
    purchase_date DATE
);

CREATE INDEX IF NOT EXISTS ix_equipment_id ON equipment(id);

COMMIT;
