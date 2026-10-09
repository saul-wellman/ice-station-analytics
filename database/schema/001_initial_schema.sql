-- Ice Station Analytics — initial schema
-- Run against the ice_station database.

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(150) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    signup_date DATE,
    customer_segment VARCHAR(30) NOT NULL
        CHECK (customer_segment IN ('Consumer', 'Business'))
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    unit_list_price NUMERIC(12,2) NOT NULL CHECK (unit_list_price >= 0),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE stores (
    store_id INTEGER PRIMARY KEY,
    store_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    store_id INTEGER REFERENCES stores(store_id),
    sales_channel VARCHAR(20) NOT NULL CHECK (sales_channel IN ('Store', 'Online')),
    order_status VARCHAR(20) NOT NULL
        CHECK (order_status IN ('Completed', 'Cancelled', 'Returned')),
    order_total NUMERIC(12,2) NOT NULL CHECK (order_total >= 0),
    CHECK (
        (sales_channel = 'Online' AND store_id IS NULL)
        OR (sales_channel = 'Store' AND store_id IS NOT NULL)
    )
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    line_amount NUMERIC(12,2) NOT NULL CHECK (line_amount >= 0),
    CHECK (discount_amount <= quantity * unit_price)
);

CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_store_id ON orders(store_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
