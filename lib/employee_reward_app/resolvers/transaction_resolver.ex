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
    # TODO: Test if emails are sent
    Mailer.cast(transaction) |> Mailer.process()

    transaction
  end

  defp notify_new_transfer_by_subscription(%Transaction{} = transaction) do
    anonimized_transaction = Sensitive.omit(transaction)
    incoming_user_id = transaction.to_user.id
    outgoing_user_id = transaction.from_user.id

    # TODO: Test and make async
    Absinthe.Subscription.publish(EmployeeRewardAppWeb.Endpoint, anonimized_transaction,
      new_transaction: [
        "incoming_transaction:#{incoming_user_id}",
        "outgoing_transaction:#{outgoing_user_id}"
      ]
    )

    # TODO: Test and make it async
    incoming_user_balance = Transactions.get_balance!(incoming_user_id)
    outgoing_user_balance = Transactions.get_balance!(outgoing_user_id)

    Absinthe.Subscription.publish(EmployeeRewardAppWeb.Endpoint, incoming_user_balance,
      update_balance: "balance:#{incoming_user_id}"
    )

    Absinthe.Subscription.publish(EmployeeRewardAppWeb.Endpoint, outgoing_user_balance,
      update_balance: "balance:#{outgoing_user_id}"
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
         |> notify_new_transfer_by_subscription()
         |> Sensitive.omit(current_user)}

      {:error, _} ->
        {:error, "unable to send credits"}
    end
  end

  defp translate_dir(:incoming), do: :to
  defp translate_dir(:outgoing), do: :from

  @spec get_recent(any, any, any) :: {:ok, list(Transactions.Transaction.t())} | {:error, any()}
  def get_recent(_parent, %{direction: direction}, %{
        context: %{current_user: %User{} = current_user}
      }) do
    transactions =
      Transactions.get_recent_transactions(current_user.id, translate_dir(direction))
      |> Sensitive.omit(current_user)

    {:ok, transactions}
  end

  def get_recent(_parent, _args, %{
        context: %{current_user: %User{} = current_user}
      }) do
    transactions =
      Transactions.get_recent_transactions(current_user.id)
      |> Sensitive.omit(current_user)

    {:ok, transactions}
  end
end
