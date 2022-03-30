defmodule EmployeeRewardApp.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias EmployeeRewardApp.Repo

  alias EmployeeRewardApp.Transactions.Transaction
  alias EmployeeRewardApp.Transactions.Balance

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def get_balance!(user_id), do: Repo.get!(Balance, user_id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    transaction =
      %Transaction{}
      |> Transaction.changeset(attrs)
      |> Repo.insert()

    with {:ok, transaction} <- transaction do
      {:ok, Repo.preload(transaction, [:from_user, :to_user])}
    else
      default -> default
    end
  end
end
