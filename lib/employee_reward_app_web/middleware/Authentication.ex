defmodule EmployeeRewardAppWeb.Middleware.Authentication do
  @moduledoc """
  Authentication middleware for throwing errors when user is not signed in.
  """
  @behaviour Absinthe.Middleware

  @spec call(Absinthe.Resolution.t(), term()) :: Absinthe.Resolution.t()
  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "user not signed in"})
    end
  end
end
