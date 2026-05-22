import os
import random
from datetime import datetime, timedelta

import numpy as np
import pandas as pd
from faker import Faker

fake = Faker()
Faker.seed(42)
np.random.seed(42)
random.seed(42)

RAW_DIR = os.path.join("data", "raw")
os.makedirs(RAW_DIR, exist_ok=True)

NUM_CUSTOMERS = 500
NUM_MERCHANTS = 100
NUM_TRANSACTIONS = 10000

PAYMENT_METHODS = [
    "credit_card",
    "debit_card",
    "bank_transfer",
    "digital_wallet",
    "buy_now_pay_later",
]

TRANSACTION_STATUSES = [
    "settled",
    "pending",
    "failed",
    "refunded",
    "chargeback",
]

MERCHANT_CATEGORIES = [
    "retail",
    "travel",
    "food_and_beverage",
    "healthcare",
    "utilities",
    "entertainment",
    "education",
    "software",
    "transportation",
    "services",
]


def generate_customers(num_customers: int) -> pd.DataFrame:
    rows = []
    for customer_id in range(1, num_customers + 1):
        profile = fake.simple_profile()
        rows.append(
            {
                "customer_id": customer_id,
                "first_name": profile["name"].split()[0],
                "last_name": profile["name"].split()[-1],
                "email": profile["mail"],
                "phone": fake.phone_number(),
                "signup_date": fake.date_between(start_date="-3y", end_date="today"),
                "country": fake.country_code(),
                "preferred_channel": random.choice(["mobile", "web", "branch"]),
            }
        )
    return pd.DataFrame(rows)


def generate_merchants(num_merchants: int) -> pd.DataFrame:
    rows = []
    for merchant_id in range(1, num_merchants + 1):
        rows.append(
            {
                "merchant_id": merchant_id,
                "merchant_name": fake.company(),
                "category": random.choice(MERCHANT_CATEGORIES),
                "city": fake.city(),
                "country": fake.country_code(),
                "onboarded_at": fake.date_between(start_date="-5y", end_date="today"),
            }
        )
    return pd.DataFrame(rows)


def random_transaction_amount() -> float:
    if random.random() < 0.12:
        amount = np.random.normal(4200, 1800)
    elif random.random() < 0.35:
        amount = np.random.normal(180, 125)
    else:
        amount = np.random.normal(45, 35)
    amount = max(amount, 1.25)
    return round(amount, 2)


def random_transaction_time() -> datetime:
    return fake.date_time_between(start_date="-365d", end_date="now")


def generate_transactions(
    num_transactions: int,
    customer_ids: list[int],
    merchant_ids: list[int],
) -> pd.DataFrame:
    rows = []
    for transaction_id in range(1, num_transactions + 1):
        customer_id = random.choice(customer_ids)
        merchant_id = random.choice(merchant_ids)
        amount = random_transaction_amount()
        status = random.choices(
            TRANSACTION_STATUSES,
            weights=[0.72, 0.14, 0.08, 0.04, 0.02],
            k=1,
        )[0]
        transaction_time = random_transaction_time()
        payment_method = random.choice(PAYMENT_METHODS)

        fraud_probability = 0.02
        if amount >= 2000:
            fraud_probability += 0.22
        if status in {"failed", "chargeback"}:
            fraud_probability += 0.12
        if transaction_time.hour in {0, 1, 2, 3, 4, 23}:
            fraud_probability += 0.04

        fraud_flag = random.random() < min(fraud_probability, 0.55)

        rows.append(
            {
                "transaction_id": transaction_id,
                "customer_id": customer_id,
                "merchant_id": merchant_id,
                "amount": amount,
                "transaction_time": transaction_time,
                "payment_method": payment_method,
                "transaction_status": status,
                "fraud_flag": fraud_flag,
            }
        )

    return pd.DataFrame(rows)


def main() -> None:
    customers_df = generate_customers(NUM_CUSTOMERS)
    merchants_df = generate_merchants(NUM_MERCHANTS)
    transactions_df = generate_transactions(
        NUM_TRANSACTIONS,
        customer_ids=list(customers_df["customer_id"]),
        merchant_ids=list(merchants_df["merchant_id"]),
    )

    customers_df.to_csv(os.path.join(RAW_DIR, "customers.csv"), index=False)
    merchants_df.to_csv(os.path.join(RAW_DIR, "merchants.csv"), index=False)
    transactions_df.to_csv(os.path.join(RAW_DIR, "transactions.csv"), index=False)


if __name__ == "__main__":
    main()