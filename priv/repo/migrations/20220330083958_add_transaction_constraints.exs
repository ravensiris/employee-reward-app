defmodule EmployeeRewardApp.Repo.Migrations.AddTransactionConstraints do
  use Ecto.Migration

  def change do
    create constraint(:transactions, :transaction_to_self, check: "from_user_id != to_user_id")
  end
end
