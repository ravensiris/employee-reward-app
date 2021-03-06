defmodule EmployeeRewardApp.Utils.Sensitive do
  @moduledoc """
  Module encompasses helper functions to remove sensitive info from structs
  """
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Transactions.Transaction

  @type omitable_structs() :: User.t() | Transaction.t()
  @type omitable() :: omitable_structs() | list(omitable_structs())

  @doc """
  Removes sensitive fields from supported structs depending on the user access level.

  First argument is the struct that has fields to be omitted.
  Second argument is the current user.

  ## Examples

        iex> omit(%EmployeeRewardApp.Users.User{email: "user@example.org"})
        %EmployeeRewardApp.Users.User{email: nil}

        iex> omit(%EmployeeRewardApp.Users.User{email: "user@example.org"}, %User{role: :admin})
        %EmployeeRewardApp.Users.User{email: "user@example.org"}
  """
  @spec omit(omitable()) :: omitable_structs()
  def omit(any) do
    omit(any, %User{})
  end

  def omit(any, %User{role: :admin}) do
    any
  end

  def omit(list_any, %User{} = user) when is_list(list_any) do
    Enum.map(list_any, &omit(&1, user))
  end

  def omit(%User{} = user, %User{id: id}) do
    u = %User{
      id: user.id,
      name: user.name,
      role: user.role
    }

    # User has more access to his own data
    if user.id == id do
      %User{u | email: user.email}
    else
      u
    end
  end

  def omit(%Transaction{} = transaction, %User{} = user) do
    %Transaction{
      transaction
      | from_user: omit(transaction.from_user, user),
        to_user: omit(transaction.to_user, user)
    }
  end

  def omit(nil, %User{}), do: nil
end
