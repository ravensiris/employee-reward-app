defmodule EmployeeRewardAppWeb.APIMeTest do
  use EmployeeRewardAppWeb.ConnCase
  import EmployeeRewardApp.Factory

  @me_query """
  query getMe{
    me {
        id
        email
        role
        name
    }
  }
  """

  @me_balance_query """
  query getMe{
    me {
        id
        email
        role
        name
        balance {
          balance
          received
          sent
        }
    }
  }
  """

  defp query_me(conn, query \\ @me_query) do
    post(conn, "/api", %{
      "query" => query
    })
  end

  describe "query 'me'" do
    test "as a member", %{member_conn: conn} do
      conn = query_me(conn)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "me" => %{
                   "id" => "ea35faa3-a465-41a5-a6eb-6e9abef58326",
                   "email" => "john.doe@example.org",
                   "role" => "member",
                   "name" => "John Doe"
                 }
               }
             }
    end

    test "as an admin", %{admin_conn: conn} do
      conn = query_me(conn)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "me" => %{
                   "id" => "1e064793-ea8d-4110-b2e1-4d8e570ab7df",
                   "email" => "admin@example.org",
                   "role" => "admin",
                   "name" => "Admin"
                 }
               }
             }
    end

    test "as unauthorized user", %{conn: conn} do
      conn = query_me(conn)

      assert %{"data" => %{"me" => nil}, "errors" => [%{"message" => "user not signed in"}]} =
               json_response(conn, 200)
    end

    test "as a in-database real user with balance", %{conn: conn} do
      u1 = insert(:user, %{role: :member})
      conn = Pow.Plug.assign_current_user(conn, u1, [])
      conn = query_me(conn, @me_balance_query)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "me" => %{
                   "balance" => %{"balance" => 50, "received" => 0, "sent" => 0},
                   "email" => u1.email,
                   "id" => u1.id,
                   "name" => u1.name,
                   "role" => to_string(u1.role)
                 }
               }
             }
    end
  end
end
