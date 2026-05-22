-- 1. Monthly transaction trends
WITH monthly_summary AS (
SELECT
DATE_TRUNC('month', transaction_time) AS month,
COUNT(*) AS transaction_count,
SUM(amount) AS total_value,
AVG(amount) AS avg_amount
FROM transactions
WHERE transaction_status = 'settled'
GROUP BY DATE_TRUNC('month', transaction_time)
)
SELECT
month,
transaction_count,
total_value,
avg_amount
FROM monthly_summary
ORDER BY month;

-- 2. Top customers by spending using RANK()
WITH customer_spend AS (
SELECT
c.customer_id,
c.first_name || ' ' || c.last_name AS customer_name,
SUM(t.amount) AS total_spend
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_status = 'settled'
GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
customer_id,
customer_name,
total_spend,
RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_spend
WHERE total_spend > 0
ORDER BY spend_rank
LIMIT 20;

-- 3. Fraud transaction analysis
WITH fraud_summary AS (
SELECT
DATE_TRUNC('month', transaction_time) AS month,
COUNT(*) FILTER (WHERE fraud_flag = TRUE) AS fraud_count,
COUNT(*) AS total_count,
SUM(amount) FILTER (WHERE fraud_flag = TRUE) AS fraud_value,
SUM(amount) AS total_value
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_time)
)
SELECT
month,
fraud_count,
total_count,
ROUND(100.0 * fraud_count / NULLIF(total_count, 0), 2) AS fraud_rate_pct,
fraud_value,
total_value
FROM fraud_summary
ORDER BY month;

-- 4. Payment method contribution percentage
WITH payment_totals AS (
SELECT
payment_method,
COUNT(*) AS transaction_count,
SUM(amount) AS total_value
FROM transactions
WHERE transaction_status = 'settled'
GROUP BY payment_method
),
overall AS (
SELECT
SUM(transaction_count) AS total_count,
SUM(total_value) AS overall_value
FROM payment_totals
)
SELECT
p.payment_method,
p.transaction_count,
p.total_value,
ROUND(100.0 * p.transaction_count / NULLIF(o.total_count, 0), 2) AS count_pct,
ROUND(100.0 * p.total_value / NULLIF(o.overall_value, 0), 2) AS value_pct
FROM payment_totals p
CROSS JOIN overall o
ORDER BY value_pct DESC;

-- 5. Running transaction totals over time
WITH ordered_transactions AS (
SELECT
transaction_time::date AS tx_date,
SUM(amount) AS daily_value
FROM transactions
WHERE transaction_status = 'settled'
GROUP BY transaction_time::date
),
running_totals AS (
SELECT
tx_date,
daily_value,
SUM(daily_value) OVER (ORDER BY tx_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_value
FROM ordered_transactions
)
SELECT
tx_date,
daily_value,
cumulative_value
FROM running_totals
ORDER BY tx_date;

-- 6. Merchant transaction rankings
WITH merchant_performance AS (
SELECT
m.merchant_id,
m.merchant_name,
COUNT(t.transaction_id) AS tx_count,
SUM(t.amount) AS total_value
FROM merchants m
JOIN transactions t ON m.merchant_id = t.merchant_id
WHERE t.transaction_status = 'settled'
GROUP BY m.merchant_id, m.merchant_name
)
SELECT
merchant_id,
merchant_name,
tx_count,
total_value,
RANK() OVER (ORDER BY total_value DESC) AS merchant_rank
FROM merchant_performance
ORDER BY merchant_rank;

-- 7. Daily average transaction analysis
WITH daily_metrics AS (
SELECT
DATE(transaction_time) AS tx_date,
COUNT(*) AS tx_count,
SUM(amount) AS total_value,
AVG(amount) AS avg_amount,
MAX(amount) AS max_amount,
MIN(amount) AS min_amount
FROM transactions
WHERE transaction_status = 'settled'
GROUP BY DATE(transaction_time)
)
SELECT
tx_date,
tx_count,
total_value,
avg_amount,
max_amount,
min_amount,
CASE
WHEN avg_amount >= 200 THEN 'High'
WHEN avg_amount >= 100 THEN 'Medium'
ELSE 'Low'
END AS avg_transaction_segment
FROM daily_metrics
ORDER BY tx_date;

-- 8. Fraud rate by payment method
WITH payment_fraud AS (
SELECT
payment_method,
COUNT(*) AS total_count,
COUNT(*) FILTER (WHERE fraud_flag = TRUE) AS fraud_count
FROM transactions
GROUP BY payment_method
)
SELECT
payment_method,
total_count,
fraud_count,
ROUND(100.0 * fraud_count / NULLIF(total_count, 0), 2) AS fraud_rate_pct
FROM payment_fraud
ORDER BY fraud_rate_pct DESC;

-- 9. Customer transaction frequency segmentation
WITH customer_freq AS (
SELECT
c.customer_id,
c.first_name || ' ' || c.last_name AS customer_name,
COUNT(t.transaction_id) AS transaction_count
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
customer_id,
customer_name,
transaction_count,
CASE
WHEN transaction_count >= 50 THEN 'Very Frequent'
WHEN transaction_count >= 20 THEN 'Frequent'
WHEN transaction_count >= 5 THEN 'Occasional'
ELSE 'Rare'
END AS frequency_segment
FROM customer_freq
ORDER BY transaction_count DESC;

-- 10. High-value transaction detection
WITH high_value_tx AS (
SELECT
t.transaction_id,
t.customer_id,
t.merchant_id,
t.amount,
t.transaction_time,
CASE
WHEN t.amount >= 1000 THEN 'Critical'
WHEN t.amount >= 500 THEN 'High'
WHEN t.amount >= 250 THEN 'Medium'
ELSE 'Normal'
END AS risk_tier
FROM transactions t
WHERE t.transaction_status = 'settled'
)
SELECT
transaction_id,
customer_id,
merchant_id,
amount,
transaction_time,
risk_tier
FROM high_value_tx
WHERE risk_tier IN ('Critical', 'High')
ORDER BY amount DESC;