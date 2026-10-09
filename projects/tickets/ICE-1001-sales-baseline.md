# ICE-1001 — Establish the Sales Baseline

**Status:** To Do  
**Priority:** Medium  
**Requester:** Analytics Lead  
**Type:** Analysis  
**Release:** v0.1

## Business request

The Head of Sales needs a baseline view of order activity before the next monthly business review. Establish the basic sales picture using the initial PostgreSQL database.

## Your task

Investigate the available data and produce a short baseline covering:
- orders by month;
- completed, cancelled, and returned order counts;
- order counts by sales channel;
- sales by product category using a clearly stated calculation;
- any reconciliation differences between order header totals and item totals.

## Acceptance criteria

- [ ] SQL is saved under `sql/analysis/`.
- [ ] Date filters and order-status filters are explicit.
- [ ] One-to-many joins do not inflate order counts or order totals.
- [ ] Header totals and item totals are compared, and mismatches are described.
- [ ] Findings are summarized in `projects/findings/ICE-1001-findings.md`.
- [ ] Assumptions and limitations are documented.
- [ ] Work is committed to Git with a meaningful commit message.

## Constraints

- Do not change source seed data to force the numbers to match.
- Do not call all order totals "revenue" without explaining the definition.
- Do not create a dashboard until the SQL results have been validated.

## Hints

Start by checking table row counts, date range, status distribution, and table relationships. You decide which queries are needed; the ticket does not prescribe the solution.
