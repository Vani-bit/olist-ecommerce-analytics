-- Power BI Reporting Datasets


-- Order-Level Sales Summary
-- One row per order to prevent payment duplication

CREATE OR REPLACE VIEW vw_order_summary AS
WITH payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value
    FROM order_payments
    GROUP BY order_id
),
item_totals AS (
    SELECT
        order_id,
        COUNT(*) AS items_count,
        SUM(price) AS items_value,
        SUM(freight_value) AS freight_value
    FROM order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp
    )::date AS purchase_month,
    COALESCE(p.payment_value, 0) AS payment_value,
    COALESCE(i.items_count, 0) AS items_count,
    COALESCE(i.items_value, 0) AS items_value,
    COALESCE(i.freight_value, 0) AS freight_value
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN payment_totals p
    ON o.order_id = p.order_id
LEFT JOIN item_totals i
    ON o.order_id = i.order_id;


-- Product Category Sales
-- One row per category

CREATE OR REPLACE VIEW vw_category_sales AS
SELECT
    COALESCE(
        t.product_category_name_english,
        pr.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS sales_value,
    ROUND(SUM(oi.freight_value), 2) AS freight_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t
    ON pr.product_category_name =
       t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1;


-- Customer Purchase Summary
-- One row per unique customer

CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    MIN(o.order_purchase_timestamp) AS first_purchase,
    MAX(o.order_purchase_timestamp) AS last_purchase,
    CASE
        WHEN COUNT(DISTINCT o.order_id) > 1
        THEN 'Repeat'
        ELSE 'One-time'
    END AS customer_type
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id;


-- Delivery Performance
-- One row per delivered order

CREATE OR REPLACE VIEW vw_delivery_performance AS
SELECT
    o.order_id,
    c.customer_state,
    c.customer_city,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    ROUND(
        (
            EXTRACT(EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )) / 86400
        )::numeric,
        2
    ) AS delivery_days,
    CASE
        WHEN o.order_delivered_customer_date
             <= o.order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL;


-- VALIDATION: Confirm Views Have Data

SELECT 'vw_order_summary' AS view_name,
       COUNT(*) AS total_rows
FROM vw_order_summary

UNION ALL

SELECT 'vw_category_sales',
       COUNT(*)
FROM vw_category_sales

UNION ALL

SELECT 'vw_customer_summary',
       COUNT(*)
FROM vw_customer_summary

UNION ALL

SELECT 'vw_delivery_performance',
       COUNT(*)
FROM vw_delivery_performance;


-- Order-level category sales for Power BI
-- Each row represents one order and product category

CREATE OR REPLACE VIEW vw_order_category_sales AS
SELECT
    oi.order_id,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS sales_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name =
       t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    oi.order_id,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    );

