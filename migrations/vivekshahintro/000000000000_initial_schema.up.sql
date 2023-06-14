-- This file contains the initial schema. Place your
-- schema here and consolidate the DDL here when needed.
-- 
-- Naming convention for migrations need to follow the rules
-- defined for migration files, documented here: https://outreach-io.atlassian.net/wiki/spaces/QSS/pages/2352709711/How-To+SmartStore+Schema+Management
-- 
-- Convention:
-- `^([0-9]+)_(.*)\.(` + string(Down) + `|` + string(Up) + `)\.(.*)$`
-- the initial schema goes in 000000000000_initial_schema.up.sql, subsequent 
-- migrations go in files following the date convention.

CREATE TABLE IF NOT EXISTS joke
(
    joke      TEXT UNIQUE NOT NULL,
    last_told TIMESTAMP   NOT NULL
);