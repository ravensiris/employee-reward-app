defmodule EmployeeRewardApp.Repo.Migrations.BalanceFromMaterializedToRegularView do
  use Ecto.Migration

  def change do
    execute "DROP TRIGGER IF EXISTS transactions_refresh_balance_trg on transactions;"
    execute "DROP TRIGGER IF EXISTS users_change_balance_trg on users;"
    execute "DROP FUNCTION IF EXISTS TRANSACTIONS_REFRESH_BALANCE;"
    execute "DROP MATERIALIZED VIEW IF EXISTS transactions_balance;"

    execute """
      CREATE VIEW transactions_balance AS
      WITH CURRENT_ACTIVE_TRANSACTIONS AS
        (SELECT TO_USER_ID,
            FROM_USER_ID,
            AMOUNT
          FROM TRANSACTIONS
          WHERE
        EXTRACT(YEAR FROM INSERTED_AT) = EXTRACT(YEAR FROM NOW())
        AND
        EXTRACT(MONTH FROM INSERTED_AT) = EXTRACT(MONTH FROM NOW())
        ),			RECEIVED AS
        (SELECT TO_USER_ID AS USER_ID,
            SUM(AMOUNT) AS RECEIVED
          FROM CURRENT_ACTIVE_TRANSACTIONS
          GROUP BY TO_USER_ID),
        SENT AS
        (SELECT FROM_USER_ID AS USER_ID,
            SUM(AMOUNT) AS SENT
          FROM CURRENT_ACTIVE_TRANSACTIONS
          GROUP BY FROM_USER_ID),
        PRE_BALANCE AS
        (SELECT COALESCE(R.USER_ID, S.USER_ID) USER_ID,
            COALESCE(RECEIVED,
              0) RECEIVED,
            COALESCE(SENT,
              0) SENT
          FROM RECEIVED R
          FULL OUTER JOIN SENT S ON R.USER_ID = S.USER_ID)
      SELECT coalesce(USER_ID, u.id) user_id,
        coalesce(RECEIVED, 0) RECEIVED,
        coalesce(SENT, 0) SENT,
        50 - coalesce(SENT, 0) + coalesce(RECEIVED,0) AS BALANCE
      FROM PRE_BALANCE pb full outer join users u on u.id = pb.user_id;
    """
  end
end
