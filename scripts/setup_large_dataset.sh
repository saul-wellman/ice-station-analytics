#!/usr/bin/env bash
# Run at the repository root: bash scripts/setup_large_dataset.sh
# Creates a separate database and never drops/overwrites an existing database.
set -Eeuo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
DB_NAME="${1:-ice_station_v2}"
DB_USER="${PGUSER:-postgres}"
DB_HOST="${PGHOST:-localhost}"
DB_PORT="${PGPORT:-5432}"
PG_BIN="${PG_BIN:-/c/Program Files/PostgreSQL/18/bin}"
PSQL="$PG_BIN/psql.exe"
CREATEDB="$PG_BIN/createdb.exe"
if [[ ! "$DB_NAME" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
  echo "Invalid database name; use letters, numbers, and underscores only." >&2; exit 2
fi
if [[ ! -f "$PSQL" || ! -f "$CREATEDB" ]]; then
  echo "PostgreSQL command-line tools not found under: $PG_BIN" >&2
  echo "Set PG_BIN to the PostgreSQL installation's bin folder and rerun." >&2; exit 2
fi
IFS= read -r -s -p "PostgreSQL password for user '$DB_USER': " PGPASSWORD
printf '\n'
export PGPASSWORD
trap 'unset PGPASSWORD' EXIT
EXISTS="$("$PSQL" -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres -tA -c "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")"
if [[ "$EXISTS" == "1" ]]; then
  echo "Database '$DB_NAME' already exists. Nothing was changed."
  echo "This script refuses to overwrite a database. Ask for guidance before removing one."; exit 2
fi
echo "Creating database '$DB_NAME'..."
"$CREATEDB" -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME"
echo "Running committed schema, generation, and validation scripts. This may take a few minutes..."
"$PSQL" -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f database/setup/v0.2_build_training_database.psql
echo "Database '$DB_NAME' is ready. The original 'ice_station' database was not changed."
