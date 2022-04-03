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
    incoming_user_id = transaction.to_user.id
    outgoing_user_id = transaction.from_user.id

    Absinthe.Subscription.publish(EmployeeRewardAppWeb.Endpoint, transaction,
      new_transaction: [
        "incoming_transaction:#{incoming_user_id}",
        "outgoing_transaction:#{outgoing_user_id}"
      ]
    )

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
         |> Sensitive.omit(current_user)
         |> notify_new_transfer_by_subscription()}

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
