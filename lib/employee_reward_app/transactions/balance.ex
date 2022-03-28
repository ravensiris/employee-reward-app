defmodule EmployeeRewardApp.Transactions.Balance do
  @moduledoc """
  Represents `User`'s balance for the *current* month *ONLY*.
  """
  use Ecto.Schema

  @type t :: %__MODULE__{
          user_id: Ecto.UUID.t() | nil,
          balance: integer() | nil,
          received: Ecto.UUID.t() | nil,
          sent: Ecto.UUID.t() | nil
        }
  @primary_key {:user_id, :binary_id, []}
  @foreign_key_type :binary_id
  schema "transactions_balance" do
    field :balance, :integer
    field :received, :integer
    field :sent, :integer
  end
end
