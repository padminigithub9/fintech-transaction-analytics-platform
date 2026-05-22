-- Seed data loader for PostgreSQL
-- Run this from the project root with psql or use the SQL commands in your preferred client.
-- If you run from project root, the relative paths below should resolve correctly.

-- Optional: clear existing rows before loading.
TRUNCATE TABLE transactions RESTART IDENTITY CASCADE;
TRUNCATE TABLE merchants RESTART IDENTITY CASCADE;
TRUNCATE TABLE customers RESTART IDENTITY CASCADE;

-- Load customer seed data
\copy customers(customer_id, first_name, last_name, email, phone, signup_date, country, preferred_channel)
FROM 'data/raw/customers.csv' WITH CSV HEADER;

-- Load merchant seed data
\copy merchants(merchant_id, merchant_name, category, country)
FROM 'data/raw/merchants.csv' WITH CSV HEADER;

-- Load transaction seed data
\copy transactions(transaction_id, customer_id, merchant_id, amount, transaction_time, payment_method, transaction_status, fraud_flag)
FROM 'data/raw/transactions.csv' WITH CSV HEADER;
