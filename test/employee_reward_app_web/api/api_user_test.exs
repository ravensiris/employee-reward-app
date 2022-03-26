defmodule EmployeeRewardAppWeb.APIUserTest do
  use EmployeeRewardAppWeb.ConnCase
  import EmployeeRewardApp.Factory

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
    |> Map.new(fn {k, v} -> {to_string(k), to_string(v)} end)
  end

  setup do
    janes =
      insert_list(10, :user, %{name: "Jane Smith"})
      |> Enum.map(&stringify_user/1)

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

  defp member_censored_user(user) do
    Map.merge(user, %{"email" => nil, "role" => nil})
  end

  defp expected_janes(result, janes, admin \\ false) do
    expected_ids = result_ids(result)

    expected =
      janes
      |> Enum.filter(fn jane -> jane["id"] in expected_ids end)

    expected =
      if admin do
        expected
      else
        Enum.map(expected, &member_censored_user/1)
      end

    %{"data" => %{"users" => expected}}
  end

  describe "query 'users' as a member" do
    test "find janes by name", %{member_conn: conn, janes: janes} do
      result = query_users(conn)
      expected = expected_janes(result, janes)

      assert length(result["data"]["users"]) == 5
      assert result == expected
    end

    test "find jane by id", %{member_conn: conn, janes: janes} do
      jane =
        List.last(janes)
        |> member_censored_user()

      jane_clipped_id =
        jane["id"]
        |> String.split("-")
        |> List.first()

      result = query_users(conn, "@#{jane_clipped_id}")
      expected = %{"data" => %{"users" => [jane]}}

      assert result == expected
    end
  end

  describe "query 'users' as an admin" do
    test "find janes by name", %{admin_conn: conn, janes: janes} do
      result = query_users(conn)
      expected = expected_janes(result, janes, true)

      assert length(result["data"]["users"]) == 5
      assert result == expected
    end

    test "find jane by id", %{admin_conn: conn, janes: janes} do
      jane = List.last(janes)

      jane_clipped_id =
        jane["id"]
        |> String.split("-")
        |> List.first()

      result = query_users(conn, "@#{jane_clipped_id}")
      expected = %{"data" => %{"users" => [jane]}}

      assert result == expected
    end
  end
end
