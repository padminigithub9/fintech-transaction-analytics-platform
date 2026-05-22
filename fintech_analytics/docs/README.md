# FinTech Transaction Analytics Platform

## Project Overview

This project is an end-to-end fintech transaction analytics platform designed to simulate a real-world digital payments ecosystem.

The platform simulates a real-world fintech payment ecosystem using synthetic datasets and performs SQL, Python, and Power BI analytics to generate business insights.

The project analyzes:

- Customer transactions
- Fraudulent transactions
- Payment behavior
- Merchant performance
- Monthly transaction trends

---

# Tech Stack

## Database

- PostgreSQL
- pgAdmin 4

## Programming & Analytics

- Python
- Pandas
- NumPy
- Faker
- Matplotlib
- Seaborn

## Visualization & BI

- Power BI
- Jupyter Notebook

## Development Environment

- VS Code

---

# Business Objectives

- Monitor transaction performance
- Detect fraudulent activities
- Analyze customer spending behavior
- Identify payment trends
- Generate business insights using SQL and Python

---

# Project Architecture

Data Generation Layer → Python + Faker  
Database Layer → PostgreSQL  
Analytics Layer → SQL + Pandas  
Visualization Layer → Power BI

---

# Project Structure

fintech_analytics/
│
├── data/
│ └── raw/
│ ├── customers.csv
│ ├── merchants.csv
│ └── transactions.csv
│
├── docs/
│ ├── README.md
│ ├── workflow.md
│ └── data_dictionary.md
│
├── notebooks/
│ └── fintech_eda.ipynb
│
├── PowerBI Dashboard/
│ └── fintech.pbix
│
├── screenshots/
│
├── sql/
│ ├── queries/
│ │ └── analytics_queries.sql
│ │
│ ├── schema/
│ │ └── create_tables.sql
│ │
│ └── seed/
│ ├── README.md
│ └── seed_data.sql
│
└── generate_data.py

---

# Project Workflow

- Design PostgreSQL schema
- Generate synthetic fintech datasets
- Load CSV datasets into PostgreSQL
- Perform SQL analytics
- Perform Python EDA
- Generate business insights
- Build Power BI dashboard

# PowerBI Dashboard

## Dashboard Preview

![FinTech Dashboard](screenshots/dashboard.png)
