-- ============================================
-- ANALYTICS VIEWS
-- Create analytics view and insights procedure
-- ============================================

USE ROLE ACCOUNTADMIN;
USE DATABASE PRODUCT_CATALOG_AI;
USE SCHEMA CATALOG;
USE WAREHOUSE CATALOG_WH;

-- Create analytics view
CREATE OR REPLACE VIEW CATEGORY_ANALYTICS AS
SELECT 
    CATEGORY,
    COUNT(*) as PRODUCT_COUNT,
    ROUND(AVG(PRICE), 2) as AVG_PRICE,
    ROUND(MIN(PRICE), 2) as MIN_PRICE,
    ROUND(MAX(PRICE), 2) as MAX_PRICE,
    ROUND(AVG(DESCRIPTION_SENTIMENT), 2) as AVG_SENTIMENT
FROM CATEGORIZED_PRODUCTS
GROUP BY CATEGORY
ORDER BY PRODUCT_COUNT DESC;

-- Verify
SELECT * FROM CATEGORY_ANALYTICS;

-- Create insights procedure
CREATE OR REPLACE PROCEDURE GENERATE_INSIGHTS()
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
    summary STRING;
    insights STRING;
BEGIN
    SELECT LISTAGG(
        CATEGORY || ': ' || PRODUCT_COUNT || ' products, Avg Price: $' || AVG_PRICE,
        '\n'
    )
    INTO summary
    FROM CATEGORY_ANALYTICS;
    
    insights := SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Analyze this product catalog data and provide 5 key business insights:\n\n' || summary
    );
    
    RETURN insights;
END;

-- Test
CALL GENERATE_INSIGHTS();

SELECT 'Analytics setup complete!' as STATUS;