-- ============================================
-- DATA INGESTION
-- Create raw products table and insert sample data
-- ============================================

USE ROLE ACCOUNTADMIN;
USE DATABASE PRODUCT_CATALOG_AI;
USE SCHEMA CATALOG;
USE WAREHOUSE CATALOG_WH;

-- Create raw products table
CREATE OR REPLACE TABLE RAW_PRODUCTS (
    PRODUCT_ID INT AUTOINCREMENT,
    RAW_PRODUCT_NAME VARCHAR(500),
    RAW_DESCRIPTION VARCHAR(5000),
    PRICE DECIMAL(10,2),
    UPLOAD_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert sample data
INSERT INTO RAW_PRODUCTS (RAW_PRODUCT_NAME, RAW_DESCRIPTION, PRICE) VALUES
('laptop dell xps 13', 'gud laptop fast performance nice screen battery ok', 999.99),
('SAMSUNG GALAXY s23 ultra', 'Amazing phone! camera is great. 5G support. battery lasts long highly recommend!!!', 1199.99),
('sony headphones WH1000XM5', 'noise canceling headphones. sound quality excellent comfortable to wear', 399.99),
('iphone 15 pro max', 'latest iphone titanium design A17 chip best camera', 1299.99),
('kindle paperwhite 11th gen', 'ereader waterproof adjustable light long battery life', 139.99),
('MacBook pro m3', 'powerful laptop for developers 16GB ram 512GB ssd retina display', 1999.99),
('airpods pro 2nd generation', 'wireless earbuds anc transparency mode spatial audio', 249.99),
('logitech mx master 3s mouse', 'ergonomic mouse programmable buttons works on glass', 99.99),
('LG OLED C3 55inch TV', '4K OLED TV smart tv webos gaming features 120hz', 1499.99),
('nintendo switch OLED', 'gaming console portable handheld vibrant screen', 349.99),
('bose soundbar 700', 'premium soundbar alexa built-in excellent bass', 799.99),
('gopro hero 12 black', 'action camera 5.3k video waterproof stabilization', 399.99),
('dyson v15 detect vacuum', 'cordless vacuum laser detection powerful suction', 649.99),
('instant pot duo 7-in-1', 'pressure cooker slow cooker rice cooker steamer', 89.99),
('fitbit charge 6', 'fitness tracker heart rate gps sleep tracking', 159.99);

-- Verify data
SELECT COUNT(*) as TOTAL_PRODUCTS FROM RAW_PRODUCTS;
SELECT * FROM RAW_PRODUCTS LIMIT 5;

SELECT 'Data ingestion complete!' as STATUS;