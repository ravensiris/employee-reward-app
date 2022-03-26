defmodule EmployeeRewardAppWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use EmployeeRewardAppWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import EmployeeRewardAppWeb.ConnCase

      alias EmployeeRewardAppWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint EmployeeRewardAppWeb.Endpoint
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(EmployeeRewardApp.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  setup %{conn: conn} do
    user = %EmployeeRewardApp.Users.User{
      email: "john.doe@example.org",
      id: "ea35faa3-a465-41a5-a6eb-6e9abef58326",
      name: "John Doe"
    }

    member_conn = Pow.Plug.assign_current_user(conn, user, [])

    {:ok, conn: conn, member_conn: member_conn}
  end

  setup %{conn: conn} do
    admin = %EmployeeRewardApp.Users.User{
      email: "admin@example.org",
      id: "1e064793-ea8d-4110-b2e1-4d8e570ab7df",
      role: :admin,
      name: "Admin"
    }

    admin_conn = Pow.Plug.assign_current_user(conn, admin, [])

    {:ok, conn: conn, admin_conn: admin_conn}
  end
end
