defmodule EmployeeRewardApp.Resolvers.User do
  alias EmployeeRewardApp.Users

  @moduledoc """
  This module defines resolvers relating to all users
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
      |> Enum.reject(fn user -> user.id == current_user.id end)

    {:ok, users}
  end
end
