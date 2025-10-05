-- ============================================
-- AI ENRICHMENT
-- Use Cortex AI to clean and enhance product data
-- ============================================

USE ROLE ACCOUNTADMIN;
USE DATABASE PRODUCT_CATALOG_AI;
USE SCHEMA CATALOG;
USE WAREHOUSE CATALOG_WH;

-- Create enriched products table
CREATE OR REPLACE TABLE ENRICHED_PRODUCTS AS
SELECT 
    PRODUCT_ID,
    RAW_PRODUCT_NAME,
    RAW_DESCRIPTION,
    PRICE,
    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Convert this to a clean, professional product name. Only return the clean name, nothing else: ' || RAW_PRODUCT_NAME
    ) as CLEAN_PRODUCT_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Rewrite this product description to be professional, engaging, and SEO-friendly. Keep it under 100 words. Description: ' || RAW_DESCRIPTION
    ) as ENHANCED_DESCRIPTION,
    SNOWFLAKE.CORTEX.SENTIMENT(RAW_DESCRIPTION) as DESCRIPTION_SENTIMENT,
    CURRENT_TIMESTAMP() as ENRICHED_DATE
FROM RAW_PRODUCTS;

-- Verify
SELECT 'ENRICHED_PRODUCTS: ' || COUNT(*) || ' rows created' as STATUS FROM ENRICHED_PRODUCTS;
SELECT PRODUCT_ID, RAW_PRODUCT_NAME, CLEAN_PRODUCT_NAME, 
       LEFT(ENHANCED_DESCRIPTION, 100) as DESCRIPTION_PREVIEW
FROM ENRICHED_PRODUCTS 
LIMIT 5;

-- Create categorized products table
CREATE OR REPLACE TABLE CATEGORIZED_PRODUCTS AS
SELECT 
    *,
    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Categorize this product into exactly ONE of these categories: Electronics, Computers, Audio, Mobile Devices, Gaming, Home Appliances, Wearables, Cameras. Only return the category name. Product: ' || 
        CLEAN_PRODUCT_NAME
    ) as CATEGORY,
    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'Extract 3-5 key features from this product description as a comma-separated list: ' || 
        ENHANCED_DESCRIPTION
    ) as KEY_FEATURES
FROM ENRICHED_PRODUCTS;

-- Verify
SELECT 'CATEGORIZED_PRODUCTS: ' || COUNT(*) || ' rows created' as STATUS FROM CATEGORIZED_PRODUCTS;
SELECT PRODUCT_ID, CLEAN_PRODUCT_NAME, CATEGORY, 
       LEFT(KEY_FEATURES, 80) as FEATURES_PREVIEW
FROM CATEGORIZED_PRODUCTS 
LIMIT 10;

SELECT 'AI enrichment complete!' as STATUS;