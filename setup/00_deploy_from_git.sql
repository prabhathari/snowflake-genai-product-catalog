-- ============================================
-- AUTOMATED DEPLOYMENT FROM GIT
-- Executes all setup scripts in order
-- ============================================

USE ROLE ACCOUNTADMIN;

-- Create Git integration (one-time setup)
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE;

-- Create Git repository
CREATE OR REPLACE GIT REPOSITORY product_catalog_repo
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/prabhathari/snowflake-genai-product-catalog.git';

-- Fetch latest
ALTER GIT REPOSITORY product_catalog_repo FETCH;

-- Create deployment procedure
CREATE OR REPLACE PROCEDURE DEPLOY_FROM_GIT()
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
    result STRING DEFAULT '';
BEGIN
    -- Execute scripts in order
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/01_initial_setup.sql;
    result := result || 'Script 01 completed\n';
    
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/02_data_ingestion.sql;
    result := result || 'Script 02 completed\n';
    
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/03_ai_enrichment.sql;
    result := result || 'Script 03 completed\n';
    
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/04_semantic_search.sql;
    result := result || 'Script 04 completed\n';
    
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/05_rag_functions.sql;
    result := result || 'Script 05 completed\n';
    
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/06_marketing_functions.sql;
    result := result || 'Script 06 completed\n';
    
    EXECUTE IMMEDIATE FROM @product_catalog_repo/branches/main/setup/07_analytics_views.sql;
    result := result || 'Script 07 completed\n';
    
    result := result || '\n✅ Full deployment complete!';
    RETURN result;
END;

-- Deploy everything with one command:
CALL DEPLOY_FROM_GIT();