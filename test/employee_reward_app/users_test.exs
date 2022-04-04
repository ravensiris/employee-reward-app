defmodule EmployeeRewardApp.UsersTest do
  use EmployeeRewardApp.DataCase
  import EmployeeRewardApp.Factory
  alias EmployeeRewardApp.Users
  alias EmployeeRewardApp.Users.User

  defp permutations([]), do: [[]]

  defp permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  describe "search_users/1" do
    setup do
      johns =
        insert_list(10, :user, %{name: "John Doe"})
        |> Enum.map(&Map.replace(&1, :password, nil))

      {:ok, %{johns: johns}}
    end

    setup %{johns: johns} do
      john = List.last(johns)
      {:ok, %{john: john}}
    end

    setup %{john: john} do
      john_clipped_id =
        john.id
        |> String.split("-")
        |> List.first()

      {:ok, %{john_clipped_id: john_clipped_id}}
    end

    test "find first 5 johns", %{johns: _johns} do
      searched = Users.search_users("john")
      assert length(searched) == 5
    end

    test "find specific john", %{john: john, john_clipped_id: john_clipped_id} do
      first = Users.search_users("john@#{john_clipped_id}") |> List.first()
      assert first == john
    end

    test "find specific john by id prefix", %{john: john, john_clipped_id: john_clipped_id} do
      first = Users.search_users("@#{john_clipped_id}") |> List.first()
      assert first == john
    end

    test "find johns with fuzzy matching" do
      permuts =
        String.graphemes("hn doe")
        |> permutations()
        |> Enum.map(fn n -> "jo" <> Enum.join(n) end)

      template_result = Users.search_users("john doe")
      results = Enum.map(permuts, &Users.search_users/1)
      Enum.each(results, fn r -> assert r == template_result end)
    end

    test "only shows users with verified email" do
      user = insert(:user, %{email_confirmed_at: nil})
      found_users = Users.search_users(user.name)
      assert length(found_users) == 0
    end
  end
end
