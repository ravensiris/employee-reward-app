defmodule EmployeeRewardApp.Resolvers.TransactionResolver do
  alias EmployeeRewardApp.Transactions
  alias EmployeeRewardApp.Transactions.Transaction
  alias EmployeeRewardApp.Utils.Sensitive
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Mailer

  @moduledoc """
  This module defines resolvers relating to `Transactions`
  """

  defp notify_new_transfer_by_email(%Transaction{} = transaction) do
    Mailer.cast(transaction) |> Mailer.process()

    transaction
  end

  defp notify_new_transfer_by_subscription(%Transaction{} = transaction) do
    Absinthe.Subscription.publish(EmployeeRewardAppWeb.Endpoint, transaction, new_transaction: "*")

    transaction
  end

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

    case transaction do
      {:ok, transaction} ->
        {:ok,
         transaction
         |> notify_new_transfer_by_email()
         |> notify_new_transfer_by_subscription()
         |> Sensitive.omit(current_user)}

      {:error, _} ->
        {:error, "unable to send credits"}
    end
  end

  @spec get_recent(any, any, any) :: {:ok, list(Transactions.Transaction.t())} | {:error, any()}
  def get_recent(_parent, _args, %{context: %{current_user: %User{} = current_user}}) do
    transactions =
      Transactions.get_recent_transactions(current_user.id)
      |> Sensitive.omit(current_user)

    {:ok, transactions}
  end
end
