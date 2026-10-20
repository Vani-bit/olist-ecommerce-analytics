
-- ==========================================
-- OLIST E-COMMERCE ANALYTICS PROJECT
-- File: 01_data_exploration.sql
-- Analysis: Order Status Distribution
-- ==========================================

-- Count the number of orders in each status

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;



-- ==========================================
-- 2. DATASET OVERVIEW
-- ==========================================

-- Count total orders and unique customers

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customer_records
FROM orders;
