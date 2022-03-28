SELECT transactions.from_user_id AS user_id,
    sum(transactions.amount) AS sent,
	EXTRACT(YEAR from inserted_at) as year,
	EXTRACT(MONTH from inserted_at) as month,
	status
   FROM transactions
  GROUP BY transactions.from_user_id, year, month, status;