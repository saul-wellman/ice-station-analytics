# Business Rules (Initial Release)

These rules define the initial training scenario. Tickets may later change them; record changes in `CHANGELOG.md` and the KPI dictionary.

1. The reporting currency is INR.
2. An order can contain multiple order items.
3. `orders.order_total` is the order header amount supplied by the fictional source system. It is not automatically the same as recognized revenue.
4. Cancelled orders should be excluded from completed-sales analysis unless a ticket explicitly asks to analyze cancellations.
5. Returned orders remain in the operational data. Return-adjusted revenue cannot be calculated until return amounts and dates are available.
6. `quantity` is the number of units on an order item.
7. `unit_price` is the selling price per unit before item-level discount.
8. `discount_amount` is the total discount for that order item, not a per-unit discount.
9. `line_amount` should be calculated as `quantity * unit_price - discount_amount`.
10. Customer names and contact details are synthetic. Do not use real personal data in this repository.
