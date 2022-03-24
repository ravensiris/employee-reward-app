defmodule EmployeeRewardAppWeb.Redirect do
  @moduledoc """
  This module allows to easily redirect within router macros like 'get'
  """
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> Plug.Conn.halt()
  end
end
