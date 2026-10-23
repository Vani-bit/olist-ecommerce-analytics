-- QUERY 1: Average Delivery Time (Days)
SELECT
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                order_delivered_customer_date
                - order_purchase_timestamp
            )) / 86400
        )::numeric, 2
    ) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- QUERY 2: On-Time vs Late Deliveries
SELECT
    CASE
        WHEN order_delivered_customer_date
             <= order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY 1;


-- QUERY 3: Average Delivery Time by State
SELECT
    c.customer_state,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                o.order_delivered_customer_date
                - o.order_purchase_timestamp
            )) / 86400
        )::numeric, 2
    ) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;


-- QUERY 4: Average Freight Cost
SELECT
    ROUND(AVG(freight_value), 2) AS avg_freight_per_item
FROM order_items;


-- QUERY 5: Delivery Status Distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
