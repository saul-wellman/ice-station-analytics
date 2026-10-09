-- Ice Station v0.2: additional operational tables.
CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL CHECK (payment_method IN ('UPI','Card','NetBanking','Cash','Wallet')),
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('Successful','Failed','Pending','Refunded')),
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    transaction_reference VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE returns (
    return_id BIGINT PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    order_item_id INTEGER NOT NULL REFERENCES order_items(order_item_id),
    return_date DATE NOT NULL,
    quantity_returned INTEGER NOT NULL CHECK (quantity_returned > 0),
    refund_amount NUMERIC(12,2) NOT NULL CHECK (refund_amount >= 0),
    return_reason VARCHAR(80) NOT NULL
);
CREATE TABLE inventory_movements (
    movement_id BIGINT PRIMARY KEY,
    movement_date DATE NOT NULL,
    store_id INTEGER NOT NULL REFERENCES stores(store_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    movement_type VARCHAR(20) NOT NULL CHECK (movement_type IN ('Opening','Purchase','Sale','Return','Adjustment')),
    quantity_change INTEGER NOT NULL CHECK (quantity_change <> 0),
    reference_type VARCHAR(30),
    reference_id BIGINT
);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_returns_order_id ON returns(order_id);
CREATE INDEX idx_returns_date ON returns(return_date);
CREATE INDEX idx_inventory_date ON inventory_movements(movement_date);
CREATE INDEX idx_inventory_store_product ON inventory_movements(store_id, product_id);
