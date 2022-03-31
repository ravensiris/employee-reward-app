defmodule EmployeeRewardAppWeb.APIUserTest do
  use EmployeeRewardAppWeb.ConnCase
  import EmployeeRewardApp.Factory
  alias EmployeeRewardApp.Utils.Sensitive

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

  defp stringify_user(user) do
    user
    |> Map.from_struct()
    |> Map.take([:email, :id, :name, :role])
    |> Map.new(fn {k, v} ->
      {to_string(k),
       if v != nil do
         to_string(v)
       else
         nil
       end}
    end)
  end

  setup do
    janes = insert_list(10, :user, %{name: "Jane Smith"})

    {:ok, janes: janes}
  end

  defp query_users(conn, name \\ "jane") do
    post(conn, "/api", %{
      "query" => @search_user_query,
      "variables" => %{name: name}
    })
    |> json_response(200)
  end

  defp result_ids(result) do
    result["data"]["users"]
    |> Enum.map(&Map.get(&1, "id"))
  end

  defp expected_janes(result, janes, admin \\ false) do
    expected_ids = result_ids(result)

    expected =
      janes
      |> Enum.filter(fn jane -> jane["id"] in expected_ids end)

    %{"data" => %{"users" => expected}}
  end

  describe "query 'users' as a member" do
    test "find janes by name", %{member_conn: conn, janes: janes} do
      result = query_users(conn)
      assert length(result["data"]["users"]) == 5
    end

    test "find jane by id", %{member_conn: conn, janes: janes} do
      jane =
        List.last(janes)
        |> Sensitive.omit_sensitive()
        |> stringify_user()

      jane_clipped_id =
        jane["id"]
        |> String.split("-")
        |> List.first()

      %{"data" => %{"users" => users}} = query_users(conn, "@#{jane_clipped_id}")
      assert List.first(users) == jane
    end
  end

  describe "query 'users' as an admin" do
    test "find janes by name", %{admin_conn: conn, janes: janes} do
      result = query_users(conn)
      assert length(result["data"]["users"]) == 5
    end

    test "find jane by id", %{admin_conn: conn, janes: janes} do
      jane = List.last(janes) |> stringify_user()

      jane_clipped_id =
        jane["id"]
        |> String.split("-")
        |> List.first()

      %{"data" => %{"users" => users}} = query_users(conn, "@#{jane_clipped_id}")
      assert List.first(users) == jane
    end
  end
end
