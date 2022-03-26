defmodule EmployeeRewardAppWeb.APIUserTest do
  use EmployeeRewardAppWeb.ConnCase
  alias EmployeeRewardApp.Repo
  alias EmployeeRewardApp.Users.User

  @search_user_query """
  query searchUser($name: String!){
    users(name: $name) {
        id
        email
        role
        name
    }
  }
  """

  @valid_attrs %{
    name: "John Doe",
    email: "john.doe@example.org",
    password: "johnnyDoe123",
    password_confirmation: "johnnyDoe123"
  }

  def user_fixture(attrs \\ %{}) do
    attrs = Map.merge(@valid_attrs, attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  setup do
    {:ok, user} = user_fixture()

    user =
      user
      |> Map.from_struct()
      |> Map.take([:email, :id, :name, :role])
      |> Map.new(fn {k, v} -> {to_string(k), to_string(v)} end)

    {:ok, users: [user]}
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

  defp query_users(conn, name \\ "john") do
    post(conn, "/api", %{
      "query" => @search_user_query,
      "variables" => %{name: name}
    })
  end

  test "query: users as a member", %{member_conn: conn, users: users} do
    conn = query_users(conn)
    users = Enum.map(users, &Map.merge(&1, %{"role" => nil, "email" => nil}))

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => users
             }
           }
  end

  test "query: me as an admin", %{admin_conn: conn, users: users} do
    conn = query_users(conn)

    assert json_response(conn, 200) == %{
             "data" => %{
               "users" => users
             }
           }
  end

  test "query: me as unauthorized user", %{conn: conn, users: users} do
    conn = query_users(conn)

    assert %{"data" => %{"users" => nil}, "errors" => [%{"message" => "user not signed in"}]} =
             json_response(conn, 200)
  end
end
