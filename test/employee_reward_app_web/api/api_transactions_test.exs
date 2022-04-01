defmodule EmployeeRewardAppWeb.APITransactionsTest do
  use EmployeeRewardAppWeb.ConnCase
  import EmployeeRewardApp.Factory

  @recent_query """
  query getTransactions{
    transactions {
        id
        amount
        fromUser {
            id
            name
            email
            role
        }
        toUser {
            id
            name
            email
            role
        }
    }
  }
  """

  defp query_recent(conn, query \\ @recent_query) do
    post(conn, "/api", %{
      "query" => query
    })
  end

  describe "query: 'transactions'" do
    test "gives 10 most recent", %{conn: conn} do
      u1 = insert(:user, %{role: :member})
      conn = Pow.Plug.assign_current_user(conn, u1, [])
      ts = insert_list(50, :transaction, %{amount: 1, from_user: u1})
      ts_ids = ts |> Enum.map(& &1.id) |> MapSet.new()
      conn = query_recent(conn)
      resp = json_response(conn, 200)
      result = resp["data"]["transactions"]
      assert length(result) == 10

      result_ids =
        result
        |> Enum.map(&Map.get(&1, "id"))
        |> MapSet.new()

      assert MapSet.subset?(result_ids, ts_ids)
    end

    test "no email leaks for members", %{conn: conn} do
      u1 = insert(:user, %{role: :member})
      conn = Pow.Plug.assign_current_user(conn, u1, [])
      ts = insert_list(50, :transaction, %{amount: 1, from_user: u1})
      conn = query_recent(conn)
      resp = json_response(conn, 200)
      result = resp["data"]["transactions"]
      result_to = Enum.map(result, &Map.get(&1, "toUser"))
      result_to_emails = Enum.map(result_to, &Map.get(&1, "email"))
      assert Enum.all?(result_to_emails, &is_nil/1)
    end
  end
end
