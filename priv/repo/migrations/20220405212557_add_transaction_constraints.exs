defmodule EmployeeRewardApp.Repo.Migrations.AddTransactionConstraints do
  use Ecto.Migration

  def up do
    execute """
      CREATE FUNCTION transaction_balance_check() RETURNS TRIGGER AS $$
      BEGIN
        IF (select balance from transactions_balance tb where tb."user_id" = NEW."from_user_id") < NEW.amount THEN
          RAISE EXCEPTION 'insufficient amount of funds' USING ERRCODE = 'check_violation', CONSTRAINT = 'insufficient_funds';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE PLPGSQL;
    """

    execute """
      CREATE OR REPLACE TRIGGER transaction_balance_check_trg
      BEFORE INSERT
      ON transactions
      FOR EACH ROW
      EXECUTE PROCEDURE transaction_balance_check();
    """

    create constraint(:transactions, :has_user_attached,
             check: "(from_user_id IS NOT NULL) OR (to_user_id IS NOT NULL)"
           )

    create constraint(:transactions, :transaction_to_self, check: "from_user_id != to_user_id")
  end

  def down do
    drop :has_user_attached
    drop :transaction_to_self
    execute "DROP FUNCTION transaction_balance_check;"
    execute "DROP TRIGGER transaction_balance_check_trg;"
  end
end
