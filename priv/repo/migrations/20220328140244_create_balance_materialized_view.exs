defmodule EmployeeRewardApp.Repo.Migrations.CreateBalanceMaterializedView do
  use Ecto.Migration

  def up do
    execute """
      CREATE MATERIALIZED VIEW transactions_balance AS
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

    execute """
    CREATE OR REPLACE FUNCTION TRANSACTIONS_REFRESH_BALANCE() RETURNS TRIGGER AS $$
    BEGIN
      REFRESH MATERIALIZED VIEW transactions_balance;
      RETURN NULL;
    END;
    $$ LANGUAGE PLPGSQL;
    """

    execute """
    CREATE TRIGGER transactions_refresh_balance_trg
    AFTER INSERT OR UPDATE OR DELETE
    ON transactions
    FOR EACH STATEMENT
    EXECUTE PROCEDURE transactions_refresh_balance();
    """

    execute """
    CREATE TRIGGER users_change_balance_trg
    AFTER INSERT OR UPDATE OR DELETE
    ON users
    FOR EACH STATEMENT
    EXECUTE PROCEDURE transactions_refresh_balance();
    """
  end

  def down do
    execute "DROP TRIGGER transactions_refresh_balance_trg ON transactions;"
    execute "DROP FUNCTION TRANSACTIONS_REFRESH_BALANCE;"
    execute "DROP MATERIALIZED VIEW transactions_balance;"
  end
end
