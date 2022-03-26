defmodule EmployeeRewardApp.Resolvers.UserResolver do
  alias EmployeeRewardApp.Users

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
        context: %{is_admin: is_admin, current_user: current_user}
      }) do
    users = Users.search_users(name)

    users =
      if is_admin do
        users
      else
        Enum.map(users, &Map.take(&1, [:id, :name]))
      end
      # Remove current_user from results
      |> Enum.reject(fn user -> user.id == current_user.id end)

    {:ok, users}
  end
end
