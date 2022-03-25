defmodule EmployeeRewardApp.Resolvers.User do
  alias EmployeeRewardApp.Users

  @moduledoc """
  This module defines resolvers relating to all users
  """
  def search_user(_parent, %{name: name}, %{context: %{is_admin: is_admin}}) do
    users = Users.search_users(name)

    users =
      if is_admin do
        users
      else
        Enum.map(users, &Map.take(&1, [:id, :name]))
      end

    {:ok, users}
  end
end
