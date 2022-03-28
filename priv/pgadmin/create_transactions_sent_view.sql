CREATE VIEW transactions_sent
 AS
 SELECT transactions.from_user_id AS user_id,
    sum(transactions.amount) AS sent,
    EXTRACT(year FROM transactions.inserted_at) AS year,
    EXTRACT(month FROM transactions.inserted_at) AS month,
    transactions.status
   FROM transactions
  GROUP BY transactions.from_user_id, (EXTRACT(year FROM transactions.inserted_at)), (EXTRACT(month FROM transactions.inserted_at)), transactions.status;
