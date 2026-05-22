-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(30),
    signup_date DATE,
    country VARCHAR(10),
    preferred_channel VARCHAR(20)
);

-- Merchants Table
CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(100),
    category VARCHAR(50),
    country VARCHAR(10)
);

-- Transactions Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    merchant_id INT REFERENCES merchants(merchant_id),
    amount NUMERIC(10,2),
    transaction_time TIMESTAMP,
    payment_method VARCHAR(30),
    transaction_status VARCHAR(30),
    fraud_flag BOOLEAN
);


SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

COPY customers
FROM 'C:/postgres_data/customers.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM customers LIMIT 10;

COPY merchants
FROM 'C:/postgres_data/merchants.csv'
DELIMITER ','
CSV HEADER;

COPY transactions
FROM 'C:/postgres_data/transactions.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM merchants;
SELECT COUNT(*) FROM transactions;
