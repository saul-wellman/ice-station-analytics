# Ice Station Analytics Architecture

## Data provisioning

Version-controlled schema and generator SQL in this repository → `psql` setup script → local PostgreSQL `ice_station_v2` database → analyst SQL and validation → Power BI semantic model/reports → documented business findings.

GitHub stores code, setup scripts, documentation and project history. It does not store the live PostgreSQL database or generated bulk rows.

## Tables in v0.2

- `customers`: customer profile and location
- `products`: product catalogue and category
- `stores`: physical store and region metadata
- `orders`: order header, date, channel, status, customer and optional store
- `order_items`: product-level quantity, price and discount
- `payments`: payment status, method, amount and transaction reference
- `returns`: item-level returned quantities and refund amounts
- `inventory_movements`: stock ledger for opening inventory, sales, returns, purchases and adjustments

## Database environments

- `ice_station`: original small v0.1 sample retained as a reference.
- `ice_station_v2`: large v0.2 synthetic dataset for the main training workflow.

## Planned extensions

Future releases may add marketing campaign data, source-system CSV imports, schema migrations, date-partitioning exercises, and incremental loads. Changes must be explicit and documented rather than silently changing existing field meanings.
