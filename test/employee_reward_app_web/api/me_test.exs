defmodule EmployeeRewardAppWeb.MeTest do
  use EmployeeRewardAppWeb.ConnCase

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

  defp query_me(conn) do
    post(conn, "/api", %{
      "query" => @me_query
    })
  end

  test "query: me as a member", %{member_conn: conn} do
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

  test "query: me as an admin", %{admin_conn: conn} do
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

  test "query: me as unauthorized user", %{conn: conn} do
    conn = query_me(conn)

    assert %{"data" => %{"me" => nil}, "errors" => [%{"message" => "user not logged in"}]} =
             json_response(conn, 200)
  end
end
