defmodule EmployeeRewardApp.Resolvers.TransactionResolver do
  alias EmployeeRewardApp.Transactions
  alias EmployeeRewardApp.Utils.Sensitive
  alias EmployeeRewardApp.Users.User

  @moduledoc """
  This module defines resolvers relating to `Transactions`
  """

  # TODO: Spec
  def send_credits(_parent, %{to: to_user_id, amount: amount}, %{
        context: %{current_user: current_user}
      }) do
    transaction =
      Transactions.create_transaction(%{
        to_user_id: to_user_id,
        amount: amount,
        from_user_id: current_user.id
      })

    with {:ok, transaction} <- transaction do
      {:ok, Sensitive.omit(transaction, current_user)}
    else
      {:error, _} -> {:error, "unable to send credits"}
    end
  end

  @spec get_recent(any, any, any) :: {:ok, list(Transactions.Transaction.t())} | {:error, any()}
  def get_recent(_parent, _args, %{context: %{current_user: %User{} = current_user}}) do
    Transactions.get_recent_transactions(current_user.id)
    |> Sensitive.omit(current_user)
  end
end
