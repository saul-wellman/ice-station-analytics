# KPI Definitions — Initial Release

Do not treat a field name as a business definition. Confirm these definitions before building reports.

| KPI | Initial definition | Caveat |
|---|---|---|
| Order count | Count of distinct orders | Specify whether cancelled/returned orders are included |
| Completed order count | Distinct orders where status = `Completed` | Does not imply payment settlement |
| Gross item value | Sum of `quantity * unit_price` for included order items | Before discounts |
| Item discounts | Sum of `discount_amount` for included order items | Discount is stored at line level |
| Net item sales | Sum of `line_amount` for included order items | Initial proxy only; returns and tax treatment are not yet modeled |
| Average order value | Net item sales divided by distinct included orders | Avoid summing order totals after joining order items |
| Customer count | Count of distinct customer IDs in the selected population | Define active/customer population per ticket |

## Reconciliation rule

Before publishing a revenue figure, compare order-header totals with the sum of item line amounts at order level. Explain mismatches and do not assume one source is correct without evidence.
