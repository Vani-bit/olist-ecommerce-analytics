
-- ==========================================
-- OLIST E-COMMERCE ANALYTICS PROJECT
-- File: 01_data_exploration.sql
-- Purpose: Initial Dataset Exploration
-- ==========================================

-- 1. Total rows in each table
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'product_category_translation', COUNT(*)
FROM product_category_translation
ORDER BY table_name;


-- 2. Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 3. Total Orders and Customer Records
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id)
        AS unique_customer_records
FROM orders;


-- 4. Purchase Date Range
SELECT
    MIN(order_purchase_timestamp) AS first_purchase,
    MAX(order_purchase_timestamp) AS last_purchase
FROM orders;


-- 5. Orders with Missing Delivery Dates
SELECT
    COUNT(*) AS missing_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NULL;


-- 6. Unique Products and Sellers
SELECT
    (SELECT COUNT(DISTINCT product_id)
     FROM products) AS unique_products,
    (SELECT COUNT(DISTINCT seller_id)
     FROM sellers) AS unique_sellers;
