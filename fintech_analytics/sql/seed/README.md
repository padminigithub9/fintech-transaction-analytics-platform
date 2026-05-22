# Seed Folder

This folder contains database seed instructions for the fintech analytics project.

## Files

- `seed_data.sql` — contains PostgreSQL `\copy` commands to load sample data from `data/raw/` into the `customers`, `merchants`, and `transactions` tables.

## Usage

From the project root, run:

```bash
psql -d your_database -f sql/seed/seed_data.sql
```

If you prefer a local client mode, run:

```bash
cd path/to/project/root
psql -d your_database
\i sql/seed/seed_data.sql
```

## Notes

- The script uses `\copy` so it reads CSV files from the client machine.
- Confirm the `data/raw/` files exist before running.
- Adjust the database name and connection method as needed.
