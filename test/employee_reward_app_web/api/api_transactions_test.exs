defmodule EmployeeRewardAppWeb.APITransactionsTest do
  use EmployeeRewardAppWeb.ConnCase
  import EmployeeRewardApp.Factory
  import Swoosh.TestAssertions

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
  @send_credits_mutation """
  mutation sendCredits($to: UUID4!, $amount: Int!){
    transaction(to: $to, amount: $amount){
      id
      amount,
      toUser{
        id
        name
        email
      },
      fromUser {
        id
        name
        email
      }
    }
  }
  """

  defp query_recent(conn, query \\ @recent_query) do
    post(conn, "/api", %{
      "query" => query
    })
  end

  defp mutation_send_credits(conn, to_user_id, amount, query \\ @send_credits_mutation) do
    post(conn, "/api", %{
      "query" => query,
      "variables" => %{to: to_user_id, amount: amount}
    })
  end

  describe "query: 'transactions'" do
    defp assign_user(conn, user) do
      Pow.Plug.assign_current_user(conn, user, [])
    end

    test "gives 10 most recent", %{conn: conn} do
      u1 = insert(:user, %{role: :member})
      conn = assign_user(conn, u1)
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
      conn = assign_user(conn, u1)
      ts = insert_list(50, :transaction, %{amount: 1, from_user: u1})
      conn = query_recent(conn)
      resp = json_response(conn, 200)
      result = resp["data"]["transactions"]
      result_to = Enum.map(result, &Map.get(&1, "toUser"))
      result_to_emails = Enum.map(result_to, &Map.get(&1, "email"))
      assert Enum.all?(result_to_emails, &is_nil/1)
    end
  end

  describe "mutation: send_credits" do
    test "user can send credits", %{conn: conn} do
      me = insert(:user, %{role: :member})
      to_user = insert(:user)

      result =
        conn
        |> assign_user(me)
        |> mutation_send_credits(to_user.id, 1)
        |> json_response(200)

      transaction_json = result["data"]["transaction"] |> Map.delete("id")

      assert transaction_json == %{
               "amount" => 1,
               "fromUser" => %{
                 "email" => me.email,
                 "id" => me.id,
                 "name" => me.name
               },
               "toUser" => %{
                 "email" => nil,
                 "id" => to_user.id,
                 "name" => to_user.name
               }
             }
    end

    test "user can't send more credits than he owns", %{conn: conn} do
      # should have 50 credits by default
      me = insert(:user, %{role: :member})
      to_user = insert(:user)

      result =
        conn
        |> assign_user(me)
        |> mutation_send_credits(to_user.id, 51)
        |> json_response(200)

      assert result["data"]["transaction"] == nil
      assert result["errors"]
    end

    test "user can't send invalid amount of credits", %{conn: conn} do
      me = insert(:user, %{role: :member})
      to_user = insert(:user)

      conn = assign_user(conn, me)

      edge_cases = [nil, -1, 0, "-1", "0", "1"]

      for amount <- edge_cases do
        result =
          conn
          |> mutation_send_credits(to_user.id, amount)
          |> json_response(200)

        assert result["data"]["transaction"] == nil
        assert result["errors"]
      end
    end

    test "sends email to recepient", %{conn: conn} do
      me = insert(:user, %{role: :member})
      to_user = insert(:user)
      conn = assign_user(conn, me)

      resp =
        conn
        |> mutation_send_credits(to_user.id, 1)
        |> json_response(200)

      transaction_id = resp["data"]["transaction"]["id"]

      transaction =
        EmployeeRewardApp.Transactions.get_transaction!(transaction_id)
        |> EmployeeRewardApp.Repo.preload([:from_user, :to_user])

      email = EmployeeRewardApp.Mailer.cast(transaction)
      assert_email_sent(email)
    end

    # TODO: Test sockets
    # Reference: https://gist.github.com/wpiekutowski/8e4de4b9c8253584765ca0106c190dad
  end
end
