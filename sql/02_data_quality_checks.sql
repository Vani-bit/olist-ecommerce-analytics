-- 1. Check for missing customer IDs
SELECT COUNT(*) AS missing_customer_ids
FROM customers
WHERE customer_id IS NULL;

-- 2. Check for duplicate order IDs
SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 3. Check for orders without matching customers
SELECT COUNT(*) AS unmatched_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 4. Check for missing delivery dates
SELECT
    order_status,
    COUNT(*) AS missing_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY missing_delivery_dates DESC;

-- 5. Check for invalid product prices
SELECT COUNT(*) AS invalid_prices
FROM order_items
WHERE price IS NULL OR price < 0;