-- =============================================================================
-- PostgreSQL Initialization Script
-- Runs automatically when the postgres container is first created.
-- Add your schema, seed data, extensions, etc. here.
-- =============================================================================

-- Enable useful extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Example: create a table
-- CREATE TABLE IF NOT EXISTS observations (
--     id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
--     created_at  TIMESTAMPTZ DEFAULT NOW(),
--     category    TEXT NOT NULL,
--     value       DOUBLE PRECISION,
--     notes       TEXT
-- );

-- Example: seed data
-- INSERT INTO observations (category, value, notes) VALUES
--     ('baseline', 42.0, 'Initial measurement'),
--     ('treatment', 58.3, 'After intervention');
