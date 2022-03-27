defmodule EmployeeRewardApp.Transactions.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "balances" do
    field :balance, :integer
    field :month, :date
    field :received, :integer
    field :sent, :integer
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:balance, :sent, :received, :month])
    |> validate_required([:balance, :sent, :received, :month])
  end
end
