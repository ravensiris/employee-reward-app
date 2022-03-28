defmodule EmployeeRewardApp.Transactions.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions_balance" do
    field :balance, :integer
    field :received, :integer
    field :sent, :integer
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:balance, :received, :sent])
    |> validate_required([:balance, :received, :sent])
  end
end
