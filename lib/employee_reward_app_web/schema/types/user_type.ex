defmodule EmployeeRewardAppWeb.Schema.Types.UserType do
  @moduledoc """
  `User` definition for Absinthe
  """
  use Absinthe.Schema.Notation
  alias EmployeeRewardAppWeb.Schema

  import_types(Schema.Types.UUID4)
  import_types(Schema.Types.BalanceType)

  object :user do
    field :id, :uuid4
    field :email, :string
    field :name, :string
    field :role, :string

    field :balance, :balance
  end
end
