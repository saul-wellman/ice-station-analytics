-- Run after schema and seed scripts.
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'stores', COUNT(*) FROM stores
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
ORDER BY table_name;

-- Expected: no rows returned.
SELECT oi.order_item_id, oi.order_id
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_id IS NULL;

-- Reconciliation check: compare order header amount with item sum.
-- This query is diagnostic; do not assume a mismatch means which side is wrong.
SELECT
    o.order_id,
    o.order_total,
    SUM(oi.line_amount) AS item_total,
    o.order_total - SUM(oi.line_amount) AS difference
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_total
HAVING o.order_total <> SUM(oi.line_amount)
ORDER BY o.order_id;
