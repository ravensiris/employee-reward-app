defmodule EmployeeRewardApp.Resolvers.Me do
  alias EmployeeRewardApp.Users.User

  @moduledoc """
  This module defines resolvers relating to the current user
  """
  @spec show_me(any, any, %{:context => %{current_user: User.t()}}) ::
          {:error, String.t()} | {:ok, map}
  def show_me(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, Map.take(current_user, [:id, :email, :role, :name])}
  end
end
