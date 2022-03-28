defmodule EmployeeRewardAppWeb.Schema.Types.BalanceType do
  @moduledoc """
  `Balance` definition for Absinthe
  """
  use Absinthe.Schema.Notation

  object :balance do
    field :balance, :integer
    field :received, :integer
    field :sent, :integer
  end
end
