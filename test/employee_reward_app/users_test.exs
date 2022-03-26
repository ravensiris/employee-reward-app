defmodule EmployeeRewardApp.UsersTest do
  use EmployeeRewardApp.DataCase
  alias EmployeeRewardApp.Users

  describe "user" do
    alias EmployeeRewardApp.Users.User
    alias EmployeeRewardApp.Repo

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

    test "search_user/1 finds user with fuzzy search" do
      {:ok, user} = user_fixture()

      assert Users.search_users("jon") == [user]
    end
  end
end
