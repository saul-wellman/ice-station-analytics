# Architecture

## Initial learning architecture

Synthetic SQL seed data → PostgreSQL relational database → SQL analysis/views → Power BI semantic model and reports → documented business findings.

## Initial entities

- `customers`: customer profile and location
- `products`: product catalogue and category
- `stores`: physical store and region metadata
- `orders`: order header, date, channel, status, customer, and store
- `order_items`: product-level quantity, price, and discount

## Planned extensions

Later releases may introduce payments, returns, inventory snapshots, marketing campaigns, and source-system extracts. These will be added through explicit schema changes and migration scripts rather than silently changing the meaning of existing fields.
