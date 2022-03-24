defmodule EmployeeRewardApp.Repo.Migrations.UserNameField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, default: "", null: false
    end
  end
end
