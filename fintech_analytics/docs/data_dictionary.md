# Data Dictionary

## customers

| Column Name       | Data Type    | Description                |
| ----------------- | ------------ | -------------------------- |
| customer_id       | INT          | Unique customer identifier |
| first_name        | VARCHAR(50)  | Customer first name        |
| last_name         | VARCHAR(50)  | Customer last name         |
| email             | VARCHAR(100) | Customer email address     |
| phone             | VARCHAR(30)  | Customer contact number    |
| signup_date       | DATE         | Customer registration date |
| country           | VARCHAR(10)  | Customer country code      |
| preferred_channel | VARCHAR(20)  | Preferred banking channel  |

---

## merchants

| Column Name   | Data Type    | Description                |
| ------------- | ------------ | -------------------------- |
| merchant_id   | INT          | Unique merchant identifier |
| merchant_name | VARCHAR(100) | Merchant business name     |
| category      | VARCHAR(50)  | Merchant business category |
| city          | VARCHAR(100) | Merchant operating city    |
| country       | VARCHAR(10)  | Merchant country code      |
| onboarded_at  | DATE         | Merchant onboarding date   |

---

## transactions

| Column Name        | Data Type     | Description                             |
| ------------------ | ------------- | --------------------------------------- |
| transaction_id     | INT           | Unique transaction identifier           |
| customer_id        | INT           | Foreign key referencing customers table |
| merchant_id        | INT           | Foreign key referencing merchants table |
| amount             | NUMERIC(10,2) | Transaction amount                      |
| transaction_time   | TIMESTAMP     | Date and time of transaction            |
| payment_method     | VARCHAR(30)   | Payment method used                     |
| transaction_status | VARCHAR(30)   | Transaction status                      |
| fraud_flag         | BOOLEAN       | Indicates fraudulent transaction        |

---

# Payment Methods

- credit_card
- debit_card
- digital_wallet
- bank_transfer
- buy_now_pay_later

---

# Transaction Status Categories

- settled
- pending
- failed
- refunded
- chargeback

---

# Fraud Logic

| fraud_flag | Meaning                          |
| ---------- | -------------------------------- |
| FALSE      | Legitimate transaction           |
| TRUE       | Potential fraudulent transaction |

---

# Dataset Summary

| Metric                      | Value  |
| --------------------------- | ------ |
| Total Customers             | 500    |
| Total Merchants             | 100    |
| Total Transactions          | 10,000 |
| Fraudulent Transactions     | 627    |
| Non-Fraudulent Transactions | 9,373  |

---

# Table Relationships

| Parent Table | Child Table  | Relationship |
| ------------ | ------------ | ------------ |
| customers    | transactions | One-to-Many  |
| merchants    | transactions | One-to-Many  |

---

# Dashboard Components

## KPI Cards

- Total Transactions
- Total Transaction Value
- Average Transaction Value
- Fraud Transactions

## Visualizations

- Monthly Transaction Value Trend
- Fraud vs Non-Fraud Transactions
- Payment Method Analysis
- Top 10 Customers by Transaction Value

---

# Tools & Technologies

- PostgreSQL
- Python
- Pandas
- Jupyter Notebook
- Power BI

---
