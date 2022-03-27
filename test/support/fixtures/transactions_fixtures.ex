defmodule EmployeeRewardApp.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmployeeRewardApp.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 42,
        status: :active
      })
      |> EmployeeRewardApp.Transactions.create_transaction()

    transaction
  end

  @doc """
  Generate a balance.
  """
  def balance_fixture(attrs \\ %{}) do
    {:ok, balance} =
      attrs
      |> Enum.into(%{
        balance: 42,
        month: ~D[2022-03-26],
        received: 42,
        sent: 42
      })
      |> EmployeeRewardApp.Transactions.create_balance()

    balance
  end
end
