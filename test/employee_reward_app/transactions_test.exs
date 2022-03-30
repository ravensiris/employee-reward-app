defmodule EmployeeRewardApp.TransactionsTest do
  use EmployeeRewardApp.DataCase

  import EmployeeRewardApp.Factory

  alias EmployeeRewardApp.Repo
  alias EmployeeRewardApp.Transactions
  alias EmployeeRewardApp.Transactions.Transaction

  defp remove_pass(user) do
    Map.replace!(user, :password, nil)
  end

  test "list_transactions/0 returns all transactions" do
    transaction = insert(:transaction) |> Repo.forget_all()
    assert Transactions.list_transactions() == [transaction]
  end

  test "get_transaction!/1 returns the transaction with given id" do
    transaction = insert(:transaction) |> Repo.forget_all()
    assert Transactions.get_transaction!(transaction.id) == transaction
  end

  describe "get_balance!/1" do
    test "returns 50 for a new user" do
      user = insert(:user)
      balance = Transactions.get_balance!(user.id)
      assert balance.balance == 50
      assert balance.sent == 0
      assert balance.received == 0
      assert balance.user_id == user.id
    end

    test "returns balance - sent after sending transaction" do
      user = insert(:user)
      transaction = insert(:transaction, %{from_user: user})
      balance = Transactions.get_balance!(user.id)
      assert balance.balance == 50 - transaction.amount
    end

    test "returns balance + received after getting transaction" do
      user = insert(:user)
      transaction = insert(:transaction, %{to_user: user})
      balance = Transactions.get_balance!(user.id)
      assert balance.balance == 50 + transaction.amount
    end

    test "returns balance + received - sent after two way transaction" do
      user = insert(:user)
      t1 = insert(:transaction, %{from_user: user, amount: 10})
      t2 = insert(:transaction, %{to_user: user, amount: 20})
      balance = Transactions.get_balance!(user.id)
      assert balance.balance == 50 - t1.amount + t2.amount
    end
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
      assert {:ok, _} = t1

      should_fail = Transactions.create_transaction(empty_pockets_attrs)
      assert {:error, _} = should_fail
      {:error, changeset} = should_fail

      assert {"user doesn't have sufficient funds for transaction",
              [constraint: :check, constraint_name: "insufficient_funds"]} =
               changeset.errors[:transactions_table]
    end

    test "transaction fails when there is no user provided" do
      invalid_attrs = %{amount: 50}
      should_fail = Transactions.create_transaction(invalid_attrs)
      assert {:error, _} = Transactions.create_transaction(invalid_attrs)

      {:error, changeset} = Transactions.create_transaction(invalid_attrs)

      assert {"transaction has to have a user attached",
              [constraint: :check, constraint_name: "has_user_attached"]} =
               changeset.errors[:transactions_table]
    end

    test "transaction preloads users" do
      u1 = insert(:user) |> remove_pass()
      u2 = insert(:user) |> remove_pass()

      {:ok, t1} =
        Transactions.create_transaction(%{from_user_id: u1.id, to_user_id: u2.id, amount: 10})

      assert t1.from_user == u1
      assert t1.to_user == u2
    end
  end
end
