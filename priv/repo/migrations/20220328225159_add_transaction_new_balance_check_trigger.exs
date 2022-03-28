defmodule EmployeeRewardApp.Repo.Migrations.AddTransactionNewBalanceCheckTrigger do
  use Ecto.Migration

  def up do
    execute """
      CREATE FUNCTION transactions_new_balance_check() RETURNS TRIGGER AS $$
      BEGIN
        IF (select balance from transactions_balance tb where tb."user_id" = NEW."from_user_id") < NEW.amount THEN
          RAISE EXCEPTION 'insufficient amount of funds' USING ERRCODE = 'check_violation', CONSTRAINT = 'insufficient_funds';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE PLPGSQL;
    """

    execute """
      CREATE OR REPLACE TRIGGER transactions_balance_check_trg
      BEFORE INSERT
      ON transactions
      FOR EACH ROW
      EXECUTE PROCEDURE transactions_new_balance_check();
    """
  end

  def down do
    execute "DROP FUNCTION transactions_new_balance_check;"
    execute "DROP TRIGGER transactions_balance_check_trg;"
  end
end
