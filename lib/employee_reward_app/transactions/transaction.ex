defmodule EmployeeRewardApp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @type status() :: :active | :cancelled

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          amount: integer() | nil,
          status: status() | nil,
          from_user: Ecto.UUID.t() | nil,
          to_user: Ecto.UUID.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
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
