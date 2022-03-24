defmodule EmployeeRewardAppWeb.AbsintheContext do
  @moduledoc """
  This module puts additional context for Absinthe resolvers.
  """
  @behaviour Plug

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  @doc """
  Put context to Absinthe options
  """
  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @spec build_context(Plug.Conn.t()) :: %{optional(:current_user) => map}
  @doc """
  Fetch current_user from session
  """
  def build_context(conn) do
    with {:ok, current_user} <- authorize(conn) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(conn) do
    case Pow.Plug.current_user(conn) do
      nil -> {:error, "user not signed in"}
      current_user -> {:ok, current_user}
    end
  end
end
