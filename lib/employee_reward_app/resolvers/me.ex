defmodule EmployeeRewardApp.Resolvers.Me do
  @moduledoc """
  This module defines resolvers relating to the current user
  """
  @spec show_me(any, any, %{:context => map}) ::
          {:error, String.t()} | {:ok, map}
  def show_me(_parent, _args, %{context: context}) do
    user = Map.get(context, :current_user)

    case user do
      nil -> {:error, "user not logged in"}
      user -> {:ok, Map.take(user, [:id, :email, :role])}
    end
  end
end
