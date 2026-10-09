-- Ice Station v0.2 large synthetic dataset.
-- Run only through database/setup/v0.2_build_training_database.psql on a fresh database.
-- Targets: 25,000 customers; 1,000 products; 30 stores; 100,000 orders;
-- 250,000 order items; 100,000 payment events; plus returns and inventory movements.
-- All data is synthetic and generated locally in PostgreSQL.
SELECT setseed(0.4242);

-- Customers: synthetic Indian names and city/state pairs.
WITH ref AS (
  SELECT
    ARRAY['Aarav','Aanya','Aditya','Aditi','Arjun','Ananya','Dev','Diya','Ishaan','Isha','Kabir','Kavya','Krishna','Meera','Mira','Neha','Rohan','Riya','Sara','Vihaan','Vivaan','Zoya','Reyansh','Myra','Nikhil','Pooja','Rahul','Simran','Tanvi','Yash']::TEXT[] AS first_names,
    ARRAY['Sharma','Verma','Patel','Jain','Gupta','Singh','Rao','Nair','Khan','Mishra','Das','Joshi','Mehta','Kulkarni','Yadav','Iyer','Chopra','Bansal','Pawar','Reddy','Malhotra','Saxena','Bose','Deshmukh','Thakur']::TEXT[] AS last_names,
    ARRAY['Bhopal','Indore','Jabalpur','Gwalior','Ujjain','Raipur','Bilaspur','Nagpur','Pune','Mumbai','Nashik','Jaipur','Kota','Delhi','Lucknow','Kanpur','Noida','Ahmedabad','Surat','Vadodara','Hyderabad','Bengaluru','Chennai','Kochi','Patna','Ranchi','Bhubaneswar','Guwahati','Amritsar','Dehradun']::TEXT[] AS cities,
    ARRAY['Madhya Pradesh','Madhya Pradesh','Madhya Pradesh','Madhya Pradesh','Madhya Pradesh','Chhattisgarh','Chhattisgarh','Maharashtra','Maharashtra','Maharashtra','Maharashtra','Rajasthan','Rajasthan','Delhi','Uttar Pradesh','Uttar Pradesh','Uttar Pradesh','Gujarat','Gujarat','Gujarat','Telangana','Karnataka','Tamil Nadu','Kerala','Bihar','Jharkhand','Odisha','Assam','Punjab','Uttarakhand']::TEXT[] AS states
), randomized AS MATERIALIZED (
  SELECT g AS customer_id,
         (1 + floor(random()*30))::INT AS first_idx,
         (1 + floor(random()*25))::INT AS last_idx,
         (1 + floor(random()*30))::INT AS location_idx,
         random() AS segment_roll,
         random() AS state_variant_roll,
         floor(random()*(CURRENT_DATE - DATE '2021-01-01' + 1))::INT AS signup_offset
  FROM generate_series(1,25000) AS g
)
INSERT INTO customers (customer_id, customer_name, city, state, signup_date, customer_segment)
SELECT r.customer_id, ref.first_names[r.first_idx] || ' ' || ref.last_names[r.last_idx],
       ref.cities[r.location_idx],
       CASE WHEN ref.states[r.location_idx]='Madhya Pradesh' AND r.state_variant_roll < 0.015
            THEN (ARRAY['MP','M.P.','Madhya pradesh'])[1 + floor(random()*3)::INT]
            ELSE ref.states[r.location_idx] END,
       DATE '2021-01-01' + r.signup_offset,
       CASE WHEN r.segment_roll < 0.08 THEN 'Business' ELSE 'Consumer' END
FROM randomized r CROSS JOIN ref;

-- Products: 1,000 catalogue items across ten categories.
WITH ref AS (
  SELECT ARRAY['Furniture','Electronics','Home Lighting','Home Storage','Lifestyle','Stationery','Kitchen','Appliances','Outdoor','Accessories']::TEXT[] AS categories
), randomized AS MATERIALIZED (
  SELECT g AS product_id,
         (1 + floor(random()*10))::INT AS category_idx,
         round((100 + random()*24900)::NUMERIC,2) AS list_price,
         random() AS active_roll
  FROM generate_series(1,1000) AS g
)
INSERT INTO products (product_id, product_name, category, unit_list_price, active)
SELECT r.product_id, ref.categories[r.category_idx] || ' SKU-' || lpad(r.product_id::TEXT,4,'0'),
       ref.categories[r.category_idx], r.list_price, r.active_roll >= 0.06
FROM randomized r CROSS JOIN ref;

-- Thirty fictional stores across Indian regions.
INSERT INTO stores (store_id,store_name,city,state,region) VALUES
(1,'Bhopal MP Nagar','Bhopal','Madhya Pradesh','Central'),(2,'Bhopal New Market','Bhopal','Madhya Pradesh','Central'),
(3,'Indore Vijay Nagar','Indore','Madhya Pradesh','Central'),(4,'Indore Palasia','Indore','Madhya Pradesh','Central'),
(5,'Jabalpur Civil Lines','Jabalpur','Madhya Pradesh','Central'),(6,'Gwalior City Centre','Gwalior','Madhya Pradesh','Central'),
(7,'Ujjain Freeganj','Ujjain','Madhya Pradesh','Central'),(8,'Raipur City Centre','Raipur','Chhattisgarh','Central'),
(9,'Bilaspur Vyapar Vihar','Bilaspur','Chhattisgarh','Central'),(10,'Nagpur Central Avenue','Nagpur','Maharashtra','West'),
(11,'Pune Baner','Pune','Maharashtra','West'),(12,'Mumbai Andheri','Mumbai','Maharashtra','West'),
(13,'Mumbai Thane','Mumbai','Maharashtra','West'),(14,'Nashik College Road','Nashik','Maharashtra','West'),
(15,'Jaipur Malviya Nagar','Jaipur','Rajasthan','North'),(16,'Kota Commercial Zone','Kota','Rajasthan','North'),
(17,'Delhi South Extension','Delhi','Delhi','North'),(18,'Lucknow Gomti Nagar','Lucknow','Uttar Pradesh','North'),
(19,'Noida Sector 18','Noida','Uttar Pradesh','North'),(20,'Ahmedabad Satellite','Ahmedabad','Gujarat','West'),
(21,'Surat Adajan','Surat','Gujarat','West'),(22,'Hyderabad Hitech City','Hyderabad','Telangana','South'),
(23,'Bengaluru Indiranagar','Bengaluru','Karnataka','South'),(24,'Chennai T Nagar','Chennai','Tamil Nadu','South'),
(25,'Kochi Edappally','Kochi','Kerala','South'),(26,'Patna Boring Road','Patna','Bihar','East'),
(27,'Ranchi Main Road','Ranchi','Jharkhand','East'),(28,'Bhubaneswar Patia','Bhubaneswar','Odisha','East'),
(29,'Guwahati GS Road','Guwahati','Assam','East'),(30,'Dehradun Rajpur Road','Dehradun','Uttarakhand','North');

-- 100,000 orders from 2023 through the date this script is run.
-- Approximately 32% Online, 68% Store; about 92% Completed, 5% Cancelled, 3% Returned.
WITH randomized AS MATERIALIZED (
  SELECT g AS order_id,
         (1 + floor(random()*25000))::INT AS customer_id,
         DATE '2023-01-01' + floor(random()*(CURRENT_DATE-DATE '2023-01-01'+1))::INT AS order_date,
         random() AS channel_roll, random() AS status_roll, random() AS store_roll
  FROM generate_series(1,100000) AS g
)
INSERT INTO orders (order_id,order_date,customer_id,store_id,sales_channel,order_status,order_total)
SELECT order_id, order_date, customer_id,
       CASE WHEN channel_roll < 0.32 THEN NULL ELSE (1 + floor(store_roll*30))::INT END,
       CASE WHEN channel_roll < 0.32 THEN 'Online' ELSE 'Store' END,
       CASE WHEN status_roll < 0.05 THEN 'Cancelled' WHEN status_roll < 0.08 THEN 'Returned' ELSE 'Completed' END,
       0.00
FROM randomized;

-- Exactly 250,000 item rows: orders cycle through 1, 2, 3, and 4 items.
WITH raw_items AS MATERIALIZED (
  SELECT o.order_id, s.item_number,
         (1 + floor(random()*1000))::INT AS product_id,
         (1 + floor(random()*3))::INT AS quantity,
         random() AS price_roll, random() AS discount_chance, random() AS discount_roll
  FROM orders o
  CROSS JOIN LATERAL generate_series(1,1+(o.order_id % 4)) AS s(item_number)
), priced AS MATERIALIZED (
  SELECT (row_number() OVER (ORDER BY raw.order_id,raw.item_number))::INT AS order_item_id,
         raw.order_id, raw.product_id, raw.quantity,
         round(p.unit_list_price*(0.85+raw.price_roll*0.30)::NUMERIC,2) AS unit_price,
         CASE WHEN raw.discount_chance < 0.25 THEN (raw.discount_roll*0.15)::NUMERIC ELSE 0::NUMERIC END AS discount_rate
  FROM raw_items raw JOIN products p ON p.product_id=raw.product_id
), discounted AS MATERIALIZED (
  SELECT order_item_id,order_id,product_id,quantity,unit_price,
         round(quantity*unit_price*discount_rate,2) AS discount_amount
  FROM priced
)
INSERT INTO order_items (order_item_id,order_id,product_id,quantity,unit_price,discount_amount,line_amount)
SELECT order_item_id,order_id,product_id,quantity,unit_price,discount_amount,
       round(quantity*unit_price-discount_amount,2)
FROM discounted;

-- Reconcile source headers to item totals, then add a small intentional set of mismatches.
UPDATE orders o SET order_total=t.item_total
FROM (SELECT order_id,round(sum(line_amount),2) AS item_total FROM order_items GROUP BY order_id) t
WHERE t.order_id=o.order_id;
UPDATE orders SET order_total=order_total+100.00
WHERE order_id % 257=0 AND order_status <> 'Cancelled';

-- One payment event per order.
WITH randomized AS MATERIALIZED (
  SELECT o.*, (1+floor(random()*5))::INT AS method_idx,
         random() AS payment_status_roll, floor(random()*4)::INT AS day_offset
  FROM orders o
)
INSERT INTO payments (payment_id,order_id,payment_date,payment_method,payment_status,amount,transaction_reference)
SELECT order_id::BIGINT,order_id,order_date+day_offset,
       (ARRAY['UPI','Card','NetBanking','Cash','Wallet'])[method_idx],
       CASE WHEN order_status='Cancelled' THEN 'Failed'
            WHEN order_status='Returned' THEN 'Successful'
            WHEN payment_status_roll < 0.015 THEN 'Failed'
            WHEN payment_status_roll < 0.035 THEN 'Pending'
            ELSE 'Successful' END,
       order_total,'IS-TXN-'||lpad(order_id::TEXT,8,'0')
FROM randomized;

-- Item-level return events for orders whose status is Returned.
WITH return_rows AS MATERIALIZED (
  SELECT o.order_id,oi.order_item_id,
         LEAST(o.order_date+(1+floor(random()*30))::INT,CURRENT_DATE) AS return_date,
         oi.quantity AS quantity_returned,oi.line_amount AS refund_amount,
         (ARRAY['Damaged item','Wrong item','Customer changed mind','Item not as described','Late delivery'])[1+floor(random()*5)::INT] AS return_reason
  FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
  WHERE o.order_status='Returned'
)
INSERT INTO returns (return_id,order_id,order_item_id,return_date,quantity_returned,refund_amount,return_reason)
SELECT (row_number() OVER (ORDER BY order_item_id))::BIGINT,order_id,order_item_id,return_date,quantity_returned,refund_amount,return_reason
FROM return_rows;

-- Inventory ledger: opening stock, completed store sales, store returns, purchases, and adjustments.
WITH opening AS (
 SELECT 1 AS event_group,(s.store_id*1000+p.product_id)::BIGINT AS sort_key,
        DATE '2023-01-01' AS movement_date,s.store_id,p.product_id,'Opening'::VARCHAR(20) AS movement_type,
        (100+floor(random()*401))::INT AS quantity_change,'OpeningStock'::VARCHAR(30) AS reference_type,NULL::BIGINT AS reference_id
 FROM stores s CROSS JOIN products p
), sales AS (
 SELECT 2 AS event_group,oi.order_item_id::BIGINT AS sort_key,o.order_date AS movement_date,o.store_id,oi.product_id,
        'Sale'::VARCHAR(20) AS movement_type,-oi.quantity AS quantity_change,'Order'::VARCHAR(30) AS reference_type,o.order_id::BIGINT AS reference_id
 FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
 WHERE o.sales_channel='Store' AND o.order_status='Completed'
), returned_stock AS (
 SELECT 3 AS event_group,r.return_id::BIGINT AS sort_key,r.return_date AS movement_date,o.store_id,oi.product_id,
        'Return'::VARCHAR(20) AS movement_type,r.quantity_returned AS quantity_change,'Return'::VARCHAR(30) AS reference_type,r.return_id::BIGINT AS reference_id
 FROM returns r JOIN orders o ON o.order_id=r.order_id JOIN order_items oi ON oi.order_item_id=r.order_item_id
 WHERE o.store_id IS NOT NULL
), purchases AS MATERIALIZED (
 SELECT 4 AS event_group,g::BIGINT AS sort_key,
        DATE '2023-01-01'+floor(random()*(CURRENT_DATE-DATE '2023-01-01'+1))::INT AS movement_date,
        (1+floor(random()*30))::INT AS store_id,(1+floor(random()*1000))::INT AS product_id,
        'Purchase'::VARCHAR(20) AS movement_type,(10+floor(random()*191))::INT AS quantity_change,
        'Purchase'::VARCHAR(30) AS reference_type,g::BIGINT AS reference_id
 FROM generate_series(1,25000) AS g
), adjustments AS MATERIALIZED (
 SELECT 5 AS event_group,g::BIGINT AS sort_key,
        DATE '2023-01-01'+floor(random()*(CURRENT_DATE-DATE '2023-01-01'+1))::INT AS movement_date,
        (1+floor(random()*30))::INT AS store_id,(1+floor(random()*1000))::INT AS product_id,
        'Adjustment'::VARCHAR(20) AS movement_type,
        CASE WHEN random()<0.5 THEN -(1+floor(random()*20))::INT ELSE (1+floor(random()*20))::INT END AS quantity_change,
        'StockCount'::VARCHAR(30) AS reference_type,g::BIGINT AS reference_id
 FROM generate_series(1,5000) AS g
), events AS (
 SELECT * FROM opening UNION ALL SELECT * FROM sales UNION ALL SELECT * FROM returned_stock
 UNION ALL SELECT * FROM purchases UNION ALL SELECT * FROM adjustments
)
INSERT INTO inventory_movements (movement_id,movement_date,store_id,product_id,movement_type,quantity_change,reference_type,reference_id)
SELECT (row_number() OVER (ORDER BY event_group,sort_key))::BIGINT,movement_date,store_id,product_id,movement_type,quantity_change,reference_type,reference_id
FROM events;
