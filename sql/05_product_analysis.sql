-- QUERY 1: Top 10 Product Categories by Sales Value
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS sales_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY sales_value DESC
LIMIT 10;


-- QUERY 2: Top 10 Products by Units Sold
SELECT
    oi.product_id,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price), 2) AS sales_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id
ORDER BY units_sold DESC
LIMIT 10;


-- QUERY 3: Average Product Price
SELECT
    ROUND(AVG(price), 2) AS average_item_price
FROM order_items;


-- QUERY 4: Top 10 Sellers by Sales Value
SELECT
    oi.seller_id,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS sales_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY sales_value DESC
LIMIT 10;


-- QUERY 5: Product Category Sales Distribution
SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS category,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY items_sold DESC;
