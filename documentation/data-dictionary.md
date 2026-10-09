# Data Dictionary — Initial Release

## customers

| Column | Type | Meaning |
|---|---|---|
| customer_id | INTEGER | Primary key |
| customer_name | VARCHAR | Synthetic customer name |
| city | VARCHAR | Customer city |
| state | VARCHAR | Customer state/UT |
| signup_date | DATE | Signup date |
| customer_segment | VARCHAR | Consumer or Business |

## products

| Column | Type | Meaning |
|---|---|---|
| product_id | INTEGER | Primary key |
| product_name | VARCHAR | Product name |
| category | VARCHAR | Product category |
| unit_list_price | NUMERIC(12,2) | Reference list price in INR |
| active | BOOLEAN | Whether product is currently active |

## stores

| Column | Type | Meaning |
|---|---|---|
| store_id | INTEGER | Primary key |
| store_name | VARCHAR | Store display name |
| city | VARCHAR | Store city |
| state | VARCHAR | Store state |
| region | VARCHAR | Business region |

## orders

| Column | Type | Meaning |
|---|---|---|
| order_id | INTEGER | Primary key |
| order_date | DATE | Date order was placed |
| customer_id | INTEGER | Customer foreign key |
| store_id | INTEGER | Nullable store foreign key; online orders have no physical store |
| sales_channel | VARCHAR | Store or Online |
| order_status | VARCHAR | Completed, Cancelled, or Returned |
| order_total | NUMERIC(12,2) | Source-system header total; validate before using as a KPI |

## order_items

| Column | Type | Meaning |
|---|---|---|
| order_item_id | INTEGER | Primary key |
| order_id | INTEGER | Order foreign key |
| product_id | INTEGER | Product foreign key |
| quantity | INTEGER | Units sold |
| unit_price | NUMERIC(12,2) | Unit selling price before discount |
| discount_amount | NUMERIC(12,2) | Total discount for the line |
| line_amount | NUMERIC(12,2) | Seeded line amount; should equal quantity × unit price − discount |

All records are synthetic.
