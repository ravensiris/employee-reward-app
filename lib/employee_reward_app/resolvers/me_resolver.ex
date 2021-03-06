defmodule EmployeeRewardApp.Resolvers.MeResolver do
  alias EmployeeRewardApp.Transactions

  defp get_fields(info) do
    project = Absinthe.Resolution.project(info)
    Enum.map(project, &Map.get(&1, :name))
  end

  @moduledoc """
  This module defines resolvers relating to the current user
  """
  def show_me(_parent, _args, %{context: %{current_user: current_user}} = info) do
    result = Map.take(current_user, [:id, :email, :role, :name])
    fields = get_fields(info)

    result =
      if "balance" in fields do
        balance = Transactions.get_balance!(current_user.id)
        Map.put(result, :balance, balance)
      else
        result
      end

    result =
      if "subscriptionToken" in fields,
        do:
          Map.put(
            result,
            :subscription_token,
            Phoenix.Token.sign(
              EmployeeRewardAppWeb.Endpoint,
              "user subscription session",
              current_user.id
            )
          ),
        else: result

    {:ok, result}
  end
end
