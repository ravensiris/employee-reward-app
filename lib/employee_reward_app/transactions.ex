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

  # TODO: Add doc
  # TODO: Add spec
  def get_balance!(user_id), do: Repo.get!(Balance, user_id)

  # TODO: Add better doc
  # TODO: Add spec
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

  defp with_direction(query \\ Transaction, user_id, direction) do
    query
    |> or_where([t], field(t, ^:"#{direction}_user_id") == ^user_id)
  end

  @type user_id() :: String.t() | Ecto.UUID.t()
  @type direction() :: :from | :to

  # TODO: Write tests
  # TODO: Add doc
  @spec get_recent_transactions(user_id()) :: [Transaction.t()]
  def get_recent_transactions(user_id) do
    get_recent_transactions(user_id, [:from, :to])
  end

  @spec get_recent_transactions(user_id(), direction()) :: [Transaction.t()]
  def get_recent_transactions(user_id, direction) when is_atom(direction) do
    get_recent_transactions(user_id, [direction])
  end

  @spec get_recent_transactions(user_id(), [direction()]) :: [Transaction.t()]
  def get_recent_transactions(user_id, direction) when is_list(direction) do
    query = Enum.reduce(direction, Transaction, fn dir, q -> with_direction(q, user_id, dir) end)

    query
    |> limit(10)
    |> order_by([t], desc: t.inserted_at)
    |> preload([:from_user, :to_user])
    |> Repo.all()
  end
end
