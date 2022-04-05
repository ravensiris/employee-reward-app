defmodule EmployeeRewardApp.Users.User do
  @moduledoc false
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  alias EmployeeRewardApp.Transactions.Balance

  @type role() :: :member | :admin

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          email: String.t() | nil,
          role: role() | nil,
          name: String.t() | nil
        }
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    pow_user_fields()
    field :role, Ecto.Enum, values: [:member, :admin], default: :member
    field :name, :string
    has_one :balance, {"transactions_balance", Balance}

    timestamps()
  end

  @doc """
  Overrides changeset for PowAssent

  See: https://github.com/pow-auth/pow_assent#populate-fields
  """
  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:name])
    |> pow_assent_user_identity_changeset(
      user_identity,
      attrs,
      user_id_attrs
    )
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:role, :name])
    |> Ecto.Changeset.validate_required([:name])
  end
end
