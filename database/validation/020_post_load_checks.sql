-- Automated validation for Ice Station v0.2.
DO $$
BEGIN
  IF (SELECT count(*) FROM customers) <> 25000 THEN RAISE EXCEPTION 'Expected 25000 customers'; END IF;
  IF (SELECT count(*) FROM products) <> 1000 THEN RAISE EXCEPTION 'Expected 1000 products'; END IF;
  IF (SELECT count(*) FROM stores) <> 30 THEN RAISE EXCEPTION 'Expected 30 stores'; END IF;
  IF (SELECT count(*) FROM orders) <> 100000 THEN RAISE EXCEPTION 'Expected 100000 orders'; END IF;
  IF (SELECT count(*) FROM order_items) <> 250000 THEN RAISE EXCEPTION 'Expected 250000 order items'; END IF;
  IF (SELECT count(*) FROM payments) <> 100000 THEN RAISE EXCEPTION 'Expected 100000 payments'; END IF;
  IF EXISTS (SELECT 1 FROM order_items oi WHERE oi.line_amount <> round(oi.quantity*oi.unit_price-oi.discount_amount,2)) THEN
    RAISE EXCEPTION 'Found inconsistent order-item line amounts';
  END IF;
END $$;
SELECT table_name,row_count FROM (
 SELECT 'customers' AS table_name,count(*)::BIGINT AS row_count FROM customers
 UNION ALL SELECT 'products',count(*)::BIGINT FROM products
 UNION ALL SELECT 'stores',count(*)::BIGINT FROM stores
 UNION ALL SELECT 'orders',count(*)::BIGINT FROM orders
 UNION ALL SELECT 'order_items',count(*)::BIGINT FROM order_items
 UNION ALL SELECT 'payments',count(*)::BIGINT FROM payments
 UNION ALL SELECT 'returns',count(*)::BIGINT FROM returns
 UNION ALL SELECT 'inventory_movements',count(*)::BIGINT FROM inventory_movements
) counts ORDER BY table_name;
SELECT count(*) AS mismatched_order_headers,
       round(100.0*count(*)/(SELECT count(*) FROM orders),2) AS pct_of_orders
FROM (
 SELECT o.order_id FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
 GROUP BY o.order_id,o.order_total HAVING o.order_total<>sum(oi.line_amount)
) mismatches;
