defmodule EmployeeRewardAppWeb.AbsintheContext do
  @moduledoc """
  This module puts additional context for Absinthe resolvers.
  """
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  @doc """
  Put context to Absinthe options
  """
  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Fetch current_user from session
  """
  def build_context(conn) do
    case Pow.Plug.current_user(conn) do
      nil -> %{}
      current_user -> %{current_user: current_user}
    end
  end
end
