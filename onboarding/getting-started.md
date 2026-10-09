# Getting Started at Ice Station

## Tools

- PostgreSQL 18 and its command-line tools (`psql`, `createdb`)
- pgAdmin for browsing tables and inspecting records
- Git Bash and Git for Windows
- Power BI Desktop for reporting work

## Get the current codebase

From the local repository root:

```bash
git pull origin main
```

## Database environments

- `ice_station` is the small v0.1 sample database already created during initial onboarding. Keep it as a reference.
- `ice_station_v2` is the larger v0.2 working dataset for realistic analysis practice.

## Build the large database from repository code

From Git Bash at the repository root, run:

```bash
bash scripts/setup_large_dataset.sh
```

Enter the PostgreSQL password for the local `postgres` account when prompted. The script creates `ice_station_v2`, runs the checked-in schema and generation SQL via `psql`, and validates expected counts. It refuses to overwrite an existing database and leaves `ice_station` unchanged.

The script assumes PostgreSQL 18 command-line tools are installed at `/c/Program Files/PostgreSQL/18/bin`. If your installation uses a different path, set `PG_BIN` to its `bin` folder when invoking the script.

## Explore with pgAdmin

After setup completes, refresh the server tree in pgAdmin and expand:

`Servers → PostgreSQL 18 → Databases → ice_station_v2 → Schemas → public → Tables`

Right-click a table and choose **View/Edit Data → All Rows** to inspect sample records. Do not edit source records during familiarisation.

## Safety

Never put a database password in GitHub, SQL source files, or chat. Do not run the large setup script against your small `ice_station` database. Use only the dedicated `ice_station_v2` target.
