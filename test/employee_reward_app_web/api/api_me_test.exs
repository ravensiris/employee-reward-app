defmodule EmployeeRewardAppWeb.APIMeTest do
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

  defp query_me(conn) do
    post(conn, "/api", %{
      "query" => @me_query
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

    test "query: me as unauthorized user", %{conn: conn} do
      conn = query_me(conn)

      assert %{"data" => %{"me" => nil}, "errors" => [%{"message" => "user not signed in"}]} =
               json_response(conn, 200)
    end
  end
end
