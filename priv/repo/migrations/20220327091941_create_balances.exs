defmodule EmployeeRewardApp.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :balance, :integer
      add :sent, :integer
      add :received, :integer
      add :month, :date
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:balances, [:user_id])
  end
end
