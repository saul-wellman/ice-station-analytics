# Ice Station — Data Analyst Simulation

Ice Station is a fictional India-focused omnichannel retailer used for a long-running, project-first Data Analyst simulation.

> All company details and data are synthetic. This is a learning project, not real employment or client work.

## Environments

- `ice_station`: the small v0.1 onboarding sample; keep it as a reference.
- `ice_station_v2`: the larger v0.2 working database, created using the committed generator and setup scripts.

Large generated rows stay in local PostgreSQL. GitHub stores their schema, generator SQL, setup automation, documentation and project history.

## Build the large training database

On Windows with Git Bash and PostgreSQL 18:

1. Fetch the latest repository changes: `git pull origin main`.
2. From the repository root, run: `bash scripts/setup_large_dataset.sh`.
3. Enter your local PostgreSQL `postgres` user's password when prompted.

The script creates `ice_station_v2`, runs the version-controlled schema and generation scripts, and validates key row counts. It refuses to overwrite a database and does not change `ice_station`.

See [the v0.2 data environment guide](documentation/v0.2-large-data-environment.md) for details.

## Repository structure

```text
onboarding/          Company context, analyst handbook and business rules
database/schema/     PostgreSQL table definitions
database/generation/ Synthetic company data generator SQL
database/setup/      Ordered psql build script
database/validation/ Automated database checks
sql/                 Your analysis, data-quality and reporting queries
projects/tickets/    Business requests with acceptance criteria
projects/findings/   Documented findings
documentation/       Data dictionary, KPI definitions and release guides
powerbi/             Power BI files and documentation
scripts/             Repeatable setup scripts
CHANGELOG.md         Project history
```

## Employee workflow

1. Read the company onboarding documents.
2. Inspect tables and records before analysis.
3. Receive one business request at a time through `projects/tickets/`.
4. Investigate with SQL, validate totals, document findings and build Power BI reports when appropriate.
5. Commit work with meaningful messages and push it to GitHub.

Never commit credentials, real personal data, or generated bulk data exports.

## v0.2 data targets

25,000 customers; 1,000 products; 30 stores; 100,000 orders; 250,000 order items; 100,000 payments; plus returns and inventory movement records. These are generator targets, not data files in GitHub.
