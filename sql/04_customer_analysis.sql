
-- ==========================================
-- OLIST E-COMMERCE ANALYTICS PROJECT
-- File: 04_customer_analysis.sql
-- Purpose: Customer Behavior Analysis
-- ==========================================


-- QUERY 1: Total Unique Customers
SELECT
    COUNT(DISTINCT customer_unique_id)
        AS total_unique_customers
FROM customers;


-- QUERY 2: Top 10 States by Order Count
SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 10;


-- QUERY 3: One-Time vs Repeat Customers
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;


-- QUERY 4: Top 10 Cities by Delivered Orders
SELECT
    c.customer_city,
    c.customer_state,
    COUNT(o.order_id) AS delivered_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY
    c.customer_city,
    c.customer_state
ORDER BY delivered_orders DESC
LIMIT 10;


-- QUERY 5: Average Orders per Customer
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(AVG(order_count), 2)
        AS avg_orders_per_customer
FROM customer_orders;
