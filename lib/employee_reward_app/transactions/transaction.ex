defmodule EmployeeRewardApp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias EmployeeRewardApp.Users.User

  @type status() :: :active | :cancelled

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          amount: integer() | nil,
          status: status() | nil,
          from_user_id: Ecto.UUID.t() | nil,
          to_user_id: Ecto.UUID.t() | nil,
          from_user: User.t() | nil,
          to_user: User.t() | nil,
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :integer
    field :status, Ecto.Enum, values: [:active, :cancelled]

    belongs_to :from_user, EmployeeRewardApp.Users.User,
      foreign_key: :from_user_id,
      references: :id

    belongs_to :to_user, EmployeeRewardApp.Users.User,
      foreign_key: :to_user_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:status, :amount])
    |> validate_required([:status, :amount])
  end
end
