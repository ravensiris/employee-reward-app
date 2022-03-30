defmodule EmployeeRewardApp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias EmployeeRewardApp.Users.User

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          amount: integer() | nil,
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
    |> cast(attrs, [:amount, :from_user_id, :to_user_id])
    |> validate_required([:amount])
    ####
    # constraints BELOW in: priv/repo/migrations/20220330083958_add_transaction_constraints.exs
    ####
    |> check_constraint(
      :transactions_table,
      name: :has_user_attached,
      message: "transaction has to have a user attached"
    )
    # Voodo magic
    # https://stackoverflow.com/questions/53122256/how-to-raise-custom-postgresql-error-and-handle-it-in-ecto
    # Check Jakub Lambrych's answer
    |> check_constraint(:transactions_table,
      name: :insufficient_funds,
      message: "user doesn't have sufficient funds for transaction"
    )
    |> check_constraint(:transactions_table,
      name: :transaction_to_self,
      message: "transaction cannot be from and to the same user"
    )
  end
end
