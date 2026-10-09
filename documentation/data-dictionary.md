# Data Dictionary — Ice Station v0.2

All customer names, locations, orders, and financial amounts are synthetic and for training only. Column names and definitions match the schema scripts in `database/schema/`.

## customers

| Column | Type | Meaning |
|---|---|---|
| customer_id | INTEGER | Customer primary key |
| customer_name | VARCHAR | Synthetic customer name |
| city | VARCHAR | Customer city |
| state | VARCHAR | Customer state/UT; a small number of deliberate spelling variants are included for data-cleaning practice |
| signup_date | DATE | Customer signup date |
| customer_segment | VARCHAR | Consumer or Business |

## products

| Column | Type | Meaning |
|---|---|---|
| product_id | INTEGER | Product primary key |
| product_name | VARCHAR | Synthetic product display name/SKU |
| category | VARCHAR | Product category |
| unit_list_price | NUMERIC | Reference list price in INR |
| active | BOOLEAN | Whether product is currently active |

## stores

| Column | Type | Meaning |
|---|---|---|
| store_id | INTEGER | Store primary key |
| store_name | VARCHAR | Fictional store name |
| city | VARCHAR | Store city |
| state | VARCHAR | Store state/UT |
| region | VARCHAR | Business region |

## orders

| Column | Type | Meaning |
|---|---|---|
| order_id | INTEGER | Order primary key |
| order_date | DATE | Date the order was placed |
| customer_id | INTEGER | Customer foreign key |
| store_id | INTEGER, nullable | Store foreign key; NULL for Online orders |
| sales_channel | VARCHAR | Store or Online |
| order_status | VARCHAR | Completed, Cancelled, or Returned |
| order_total | NUMERIC | Source-system order-header total; reconcile with item totals before using as a KPI |

## order_items

| Column | Type | Meaning |
|---|---|---|
| order_item_id | INTEGER | Order-item primary key |
| order_id | INTEGER | Order foreign key |
| product_id | INTEGER | Product foreign key |
| quantity | INTEGER | Units on the line |
| unit_price | NUMERIC | Selling price per unit before line discount |
| discount_amount | NUMERIC | Total discount for the line |
| line_amount | NUMERIC | Expected to equal quantity × unit_price − discount_amount |

## payments

| Column | Type | Meaning |
|---|---|---|
| payment_id | BIGINT | Payment-event primary key |
| order_id | INTEGER | Order foreign key |
| payment_date | DATE | Simulated payment event date |
| payment_method | VARCHAR | UPI, Card, NetBanking, Cash, or Wallet |
| payment_status | VARCHAR | Successful, Failed, Pending, or Refunded |
| amount | NUMERIC | Payment event amount in INR |
| transaction_reference | VARCHAR | Synthetic unique reference |

## returns

| Column | Type | Meaning |
|---|---|---|
| return_id | BIGINT | Return-event primary key |
| order_id | INTEGER | Order foreign key |
| order_item_id | INTEGER | Returned order-item foreign key |
| return_date | DATE | Simulated return date |
| quantity_returned | INTEGER | Units returned on the line |
| refund_amount | NUMERIC | Simulated refund amount in INR |
| return_reason | VARCHAR | Synthetic return reason |

## inventory_movements

| Column | Type | Meaning |
|---|---|---|
| movement_id | BIGINT | Inventory-event primary key |
| movement_date | DATE | Movement date |
| store_id | INTEGER | Store foreign key |
| product_id | INTEGER | Product foreign key |
| movement_type | VARCHAR | Opening, Purchase, Sale, Return, or Adjustment |
| quantity_change | INTEGER | Positive means stock in; negative means stock out |
| reference_type | VARCHAR | Source event type, if applicable |
| reference_id | BIGINT | Synthetic reference to a business event; not enforced as a foreign key |

## Grain and joins

- One `customers` row represents one customer; one customer may have many orders.
- One `orders` row represents one order; an order can have one or more `order_items` rows.
- Each order item references one product.
- One order has one synthetic payment event in v0.2; future versions may add split payments and retries.
- One returned order may have multiple item-level `returns` records.
- One inventory movement is a single stock ledger event.

Beware of double-counting `orders.order_total` after joining to `order_items`, because an order total repeats once per line item.
