defmodule EmployeeRewardApp.Resolvers.UserResolver do
  alias EmployeeRewardApp.Users
  alias EmployeeRewardApp.Utils.Sensitive

  @moduledoc """
  This module defines resolvers relating to all users
  """

  @spec search_user(any, %{:name => String.t(), optional(any) => any}, %{
          :context => %{
            :current_user => Users.User.t(),
            :is_admin => boolean(),
            optional(any) => any
          },
          optional(any) => any
        }) :: {:ok, list(Users.User.t())}
  @doc """
  Resolver used for finding users by `name`.

  Returns top 5 matching users except the current user.

  `name` can include the id of the user as names are not unique and there could
  be more than 5 John Smiths
  """
  def search_user(_parent, %{name: name}, %{
        context: %{current_user: current_user}
      }) do
    users =
      Users.search_users(name)
      |> Enum.reject(fn user -> user.id == current_user.id end)
      |> Enum.map(&Sensitive.omit_sensitive(&1, current_user))

    {:ok, users}
  end
end
