# Analyst Handbook

## How work arrives

Requests arrive as tickets in `projects/tickets/`. Treat each ticket as a business request, not as a prescribed SQL exercise.

## Standard workflow

1. **Clarify:** restate the business question and define the reporting period.
2. **Explore:** inspect table structures, row counts, keys, nulls, and date ranges.
3. **Investigate:** write SQL to test possible explanations.
4. **Validate:** reconcile totals, check duplicates, and compare relevant segments.
5. **Communicate:** summarize what changed, likely drivers, caveats, and recommended next steps.
6. **Deliver:** save queries, screenshots or report files where appropriate, and a short findings note.
7. **Version:** commit related changes with a clear message.

## Quality expectations

- Never assume that `order_total` means recognized revenue without checking the KPI definition.
- Avoid double-counting orders after joining one-to-many tables.
- Make filters and date boundaries explicit.
- Separate confirmed facts from hypotheses.
- Report data limitations rather than silently filling gaps.
- Prefer repeatable checks over manually inspecting individual records.

## Git convention

Use a branch for a substantial ticket when comfortable, for example:
`feature/ICE-1001-sales-baseline`

Example commit messages:
- `docs: add sales KPI definitions`
- `feat(sql): add monthly sales baseline`
- `fix(sql): prevent duplicate order totals`
- `docs: record ICE-1001 findings`

For early practice, a direct commit to `main` is acceptable; we will introduce branches and pull requests gradually.
