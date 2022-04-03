defmodule EmployeeRewardAppWeb.Schema.Types.UserType do
  @moduledoc """
  `User` definition for Absinthe
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, :uuid4
    field :email, :string
    field :name, :string
    field :role, :string

    field :balance, :balance
    field :subscription_token, :string
  end
end
