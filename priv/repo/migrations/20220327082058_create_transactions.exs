defmodule EmployeeRewardApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer
      add :from_user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :to_user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:from_user_id])
    create index(:transactions, [:to_user_id])

    create constraint(:transactions, :has_user_attached,
             check: "(from_user_id IS NOT NULL) OR (to_user_id IS NOT NULL)"
           )
  end
end
