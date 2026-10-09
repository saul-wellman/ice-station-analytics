# Getting Started

## 1. Install tools

Install PostgreSQL (version 16 or later is recommended), pgAdmin or another SQL client, Git, and Power BI Desktop.

## 2. Create the database

In pgAdmin, connect to your local PostgreSQL server and create a database named `ice_station`.

Alternatively, from a terminal where `psql` is available:

```bash
createdb -U postgres ice_station
```

## 3. Run the SQL files in order

Run these files against the `ice_station` database:

1. `database/schema/001_initial_schema.sql`
2. `database/seed/002_seed_data.sql`
3. `database/validation/003_smoke_tests.sql`

In pgAdmin, open each file in Query Tool and execute it. The seed script uses `INSERT` statements and can be rerun only after the tables are emptied or the database is recreated.

## 4. Confirm setup

The validation script reports row counts and checks for orphan order items. Investigate any unexpected result rather than ignoring it.

## 5. Connect Power BI later

In Power BI Desktop, choose **Get data → PostgreSQL database**, enter your server (usually `localhost`) and database (`ice_station`), then select Import or DirectQuery. For this learning project, start with **Import** unless a ticket asks you to compare modes.

If Power BI cannot connect, confirm that PostgreSQL is running and that you have the correct host, port (usually 5432), database, username, and password. Never put your database password in GitHub.

## Troubleshooting

- **Database does not exist:** create `ice_station` first.
- **Permission denied:** use a database role with permission to create/read tables.
- **Relation already exists:** the schema was already run; use a fresh practice database or inspect the existing tables before rerunning.
- **CSV/SQL encoding issue:** use UTF-8.
