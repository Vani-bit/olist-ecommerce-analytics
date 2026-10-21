
-- ==========================================
-- OLIST E-COMMERCE ANALYTICS
-- 03: SALES ANALYSIS
-- ==========================================

-- KPI 1: Total Recorded Payment Value
SELECT
    ROUND(SUM(payment_value), 2)
        AS total_payment_value
FROM order_payments;


-- KPI 2: Delivered Order Payment Value
SELECT
    ROUND(SUM(p.payment_value), 2)
        AS delivered_payment_value
FROM order_payments p
JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_status = 'delivered';


-- KPI 3: Average Payment per Order
SELECT
    ROUND(AVG(order_total), 2)
        AS average_payment_per_order
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS order_total
    FROM order_payments
    GROUP BY order_id
) payments;


-- KPI 4: Monthly Delivered Payment Trends
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date
        AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2)
        AS total_payment_value
FROM orders o
JOIN order_payments p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


-- KPI 5: Top 10 Product Categories by Item Sales
SELECT
    COALESCE(
        t.product_category_name_english,
        pr.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS item_sales_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN product_category_translation t
    ON pr.product_category_name =
       t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY item_sales_value DESC
LIMIT 10;


-- KPI 6: Payment Method Distribution
SELECT
    payment_type,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2)
        AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
