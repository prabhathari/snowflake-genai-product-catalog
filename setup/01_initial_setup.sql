-- ============================================
-- INITIAL SETUP
-- Create database, schema, and warehouse
-- ============================================

USE ROLE ACCOUNTADMIN;

-- Create database
CREATE OR REPLACE DATABASE PRODUCT_CATALOG_AI;

-- Create schema
CREATE OR REPLACE SCHEMA PRODUCT_CATALOG_AI.CATALOG;

-- Set context
USE DATABASE PRODUCT_CATALOG_AI;
USE SCHEMA CATALOG;

-- Create warehouse
CREATE OR REPLACE WAREHOUSE CATALOG_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Use warehouse
USE WAREHOUSE CATALOG_WH;

SELECT 'Setup complete!' as STATUS;