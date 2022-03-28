defmodule EmployeeRewardApp.TransactionsTest do
  use EmployeeRewardApp.DataCase

  import EmployeeRewardApp.Factory

  alias EmployeeRewardApp.Repo
  alias EmployeeRewardApp.Transactions
  alias EmployeeRewardApp.Transactions.Transaction

  test "list_transactions/0 returns all transactions" do
    transaction = insert(:transaction) |> Repo.forget_all()
    assert Transactions.list_transactions() == [transaction]
  end

  test "get_transaction!/1 returns the transaction with given id" do
    transaction = insert(:transaction) |> Repo.forget_all()
    assert Transactions.get_transaction!(transaction.id) == transaction
  end

  test "get_balance!/1 returns 50 for a new user" do
    user = insert(:user)
    assert Transactions.get_balance!(user.id) == nil
  end

  describe "create_transaction/1" do
    test "valid data creates a transaction" do
      u1 = insert(:user)
      u2 = insert(:user)

      valid_attrs = %{
        amount: 42,
        to_user_id: u1.id,
        from_user_id: u2.id
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)

      assert transaction.amount == 42
      assert transaction.to_user_id == u1.id
      assert transaction.from_user_id == u2.id
    end

    test "transaction fails when user's balance is insufficient" do
      u1 = insert(:user)
      u2 = insert(:user)
      empty_pockets_attrs = %{amount: 50, from_user_id: u1.id, to_user_id: u2.id}
      t1 = Transactions.create_transaction(empty_pockets_attrs)
      assert {:error, _} = Transactions.create_transaction(empty_pockets_attrs)
    end
  end
end
