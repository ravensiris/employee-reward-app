defmodule EmployeeRewardAppWeb.Schema.Types.TransactionType do
  @moduledoc """
  `Transaction` definition for Absinthe
  """
  use Absinthe.Schema.Notation

  object :transaction do
    field :id, :uuid4
    field :from_user, :user
    field :to_user, :user
    field :amount, :integer
  end
end
