-- ============================================
-- RAG Q&A SYSTEM
-- Create question answering procedure
-- ============================================

USE ROLE ACCOUNTADMIN;
USE DATABASE PRODUCT_CATALOG_AI;
USE SCHEMA CATALOG;
USE WAREHOUSE CATALOG_WH;

-- Create Q&A procedure
CREATE OR REPLACE PROCEDURE ASK_PRODUCT_CATALOG(user_question STRING)
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
    context STRING;
    answer STRING;
BEGIN
    -- Get top 5 relevant products
    LET res RESULTSET := (
        SELECT 
            LISTAGG(
                'Product: ' || CLEAN_PRODUCT_NAME || 
                ' | Price: $' || PRICE || 
                ' | Description: ' || ENHANCED_DESCRIPTION,
                '\n'
            ) as CONTEXT
        FROM (
            SELECT 
                p.CLEAN_PRODUCT_NAME,
                p.ENHANCED_DESCRIPTION,
                p.PRICE,
                VECTOR_COSINE_SIMILARITY(p.EMBEDDING, SNOWFLAKE.CORTEX.EMBED_TEXT_768('e5-base-v2', :user_question)) as SIMILARITY_SCORE
            FROM PRODUCTS_WITH_EMBEDDINGS p
            ORDER BY SIMILARITY_SCORE DESC
            LIMIT 5
        )
    );
    
    LET c1 CURSOR FOR res;
    OPEN c1;
    FETCH c1 INTO context;
    CLOSE c1;
    
    answer := SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-8b',
        'You are a helpful product expert. Based on the following product catalog, answer the user question accurately and helpfully.\n\n' ||
        'Product Catalog:\n' || context || '\n\n' ||
        'User Question: ' || :user_question || '\n\n' ||
        'Answer:'
    );
    
    RETURN answer;
END;

-- Test
CALL ASK_PRODUCT_CATALOG('What is the best laptop under $1500?');

SELECT 'RAG Q&A system setup complete!' as STATUS;