-- ============================================
-- MARKETING FUNCTIONS
-- Create procedures for marketing content generation
-- ============================================

USE ROLE ACCOUNTADMIN;
USE DATABASE PRODUCT_CATALOG_AI;
USE SCHEMA CATALOG;
USE WAREHOUSE CATALOG_WH;

-- Product comparison procedure
CREATE OR REPLACE PROCEDURE COMPARE_PRODUCTS(category_name STRING)
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
    context STRING;
    comparison STRING;
BEGIN
    LET res RESULTSET := (
        SELECT LISTAGG(
            CLEAN_PRODUCT_NAME || ' ($' || PRICE || '): ' || 
            ENHANCED_DESCRIPTION || ' Key features: ' || KEY_FEATURES,
            '\n\n'
        ) as CONTEXT
        FROM CATEGORIZED_PRODUCTS
        WHERE UPPER(CATEGORY) = UPPER(:category_name)
        LIMIT 5
    );
    
    LET c1 CURSOR FOR res;
    OPEN c1;
    FETCH c1 INTO context;
    CLOSE c1;
    
    comparison := SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Create a detailed product comparison for these products. Include pros/cons:\n\n' || context
    );
    
    RETURN comparison;
END;

-- Marketing email procedure
CREATE OR REPLACE PROCEDURE GENERATE_MARKETING_EMAIL(product_id_input INT)
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
    prod_name STRING;
    prod_desc STRING;
    prod_price DECIMAL;
    prod_features STRING;
    email STRING;
BEGIN
    SELECT CLEAN_PRODUCT_NAME, ENHANCED_DESCRIPTION, PRICE, KEY_FEATURES
    INTO prod_name, prod_desc, prod_price, prod_features
    FROM CATEGORIZED_PRODUCTS
    WHERE PRODUCT_ID = :product_id_input;
    
    email := SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Write a compelling marketing email for this product. Include subject line and call-to-action:\n\n' ||
        'Product: ' || prod_name || '\n' ||
        'Price: $' || prod_price || '\n' ||
        'Description: ' || prod_desc || '\n' ||
        'Key Features: ' || prod_features
    );
    
    RETURN email;
END;

-- Test
CALL GENERATE_MARKETING_EMAIL(1);

SELECT 'Marketing functions setup complete!' as STATUS;