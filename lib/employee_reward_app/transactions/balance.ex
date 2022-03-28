defmodule EmployeeRewardApp.Transactions.Balance do
  use Ecto.Schema

  @primary_key {:user_id, :binary_id, []}
  @foreign_key_type :binary_id
  schema "transactions_balance" do
    field :balance, :integer
    field :received, :integer
    field :sent, :integer
  end
end
