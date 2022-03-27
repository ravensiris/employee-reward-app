defmodule EmployeeRewardApp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :integer
    field :status, Ecto.Enum, values: [:active, :cancelled]
    field :from_user, :binary_id
    field :to_user, :binary_id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:status, :amount])
    |> validate_required([:status, :amount])
  end
end
