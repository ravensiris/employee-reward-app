defmodule EmployeeRewardApp.Resolvers.TransactionResolver do
  alias EmployeeRewardApp.Transactions

  @moduledoc """
  This module defines resolvers relating to `Transactions`
  """

  # TODO: Spec
  # BUG: 500 on any error, handle ecto fails
  def send_credits(_parent, %{to: to_user_id, amount: amount}, %{
        context: %{current_user: current_user}
      }) do
    Transactions.create_transaction(%{
      to_user_id: to_user_id,
      amount: amount,
      from_user_id: current_user.id
    })
  end

  # TODO: Spec
  # BUG: 500 on any error
  def get_recent(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, Transactions.get_recent_transactions(current_user.id)}
  end
end
