# Ice Station Analytics

A fictional, India-focused retail company used to simulate the day-to-day work of a junior Data Analyst.

> **Important:** Ice Station is fictional. All records and business events in this repository are synthetic and must not be represented as real client work.

## Mission

Work as a newly onboarded Data Analyst. Learn the company's data, investigate business questions, write PostgreSQL, build Power BI reports, document findings, and manage changes with Git.

## Technology

- PostgreSQL 16+
- SQL
- Power BI Desktop
- Git and GitHub
- Jira-style work tickets (simulated in `projects/tickets/`)

## Repository map

```text
onboarding/       Company context, handbook, business rules, setup guide
database/         PostgreSQL schema, seed data, validation queries
data/             Small synthetic CSV extracts and data dictionary
sql/              Your analysis, investigations, and data-quality queries
powerbi/          Dashboard specifications and report documentation
projects/tickets/ Business requests with acceptance criteria
documentation/    Data dictionary, KPI definitions, architecture
scripts/          Optional synthetic data generator
CHANGELOG.md      Version history
```

## Your first-week onboarding

1. Read `onboarding/company-overview.md`.
2. Read `onboarding/analyst-handbook.md` and `documentation/kpi-definitions.md`.
3. Install PostgreSQL and a client such as pgAdmin.
4. Create a database named `ice_station`.
5. Run `database/schema/001_initial_schema.sql`.
6. Run `database/seed/002_seed_data.sql`.
7. Run `database/validation/003_smoke_tests.sql`.
8. Start with ticket `ICE-1001` in `projects/tickets/ICE-1001-sales-baseline.md`.
9. Save your work in the correct folder and use Git commits.

Detailed setup instructions are in `onboarding/getting-started.md`.

## Working agreement

- Do not change raw seed records to make a query look correct. Investigate first.
- Keep business definitions in documentation and update them when requirements change.
- Use readable SQL, clear names, and comments for non-obvious logic.
- Validate totals before presenting results.
- Do not commit credentials, connection strings containing passwords, or private data.
- Every project should include the question, approach, SQL, validation, findings, and limitations.
- This is a learning simulation, not evidence of employment at a real company.

## Current release

**v0.1 — Onboarding foundation:** company context, initial schema, synthetic seed data, validation queries, KPI definitions, and first analyst ticket.
