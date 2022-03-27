defmodule EmployeeRewardApp.TransactionsTest do
  use EmployeeRewardApp.DataCase

  alias EmployeeRewardApp.Transactions

  describe "transactions" do
    alias EmployeeRewardApp.Transactions.Transaction

    import EmployeeRewardApp.TransactionsFixtures

    @invalid_attrs %{amount: nil, status: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{amount: 42, status: :active}

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.amount == 42
      assert transaction.status == :active
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{amount: 43, status: :cancelled}

      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, update_attrs)
      assert transaction.amount == 43
      assert transaction.status == :cancelled
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end

  describe "balances" do
    alias EmployeeRewardApp.Transactions.Balance

    import EmployeeRewardApp.TransactionsFixtures

    @invalid_attrs %{balance: nil, month: nil, received: nil, sent: nil}

    test "list_balances/0 returns all balances" do
      balance = balance_fixture()
      assert Transactions.list_balances() == [balance]
    end

    test "get_balance!/1 returns the balance with given id" do
      balance = balance_fixture()
      assert Transactions.get_balance!(balance.id) == balance
    end

    test "create_balance/1 with valid data creates a balance" do
      valid_attrs = %{balance: 42, month: ~D[2022-03-26], received: 42, sent: 42}

      assert {:ok, %Balance{} = balance} = Transactions.create_balance(valid_attrs)
      assert balance.balance == 42
      assert balance.month == ~D[2022-03-26]
      assert balance.received == 42
      assert balance.sent == 42
    end

    test "create_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_balance(@invalid_attrs)
    end

    test "update_balance/2 with valid data updates the balance" do
      balance = balance_fixture()
      update_attrs = %{balance: 43, month: ~D[2022-03-27], received: 43, sent: 43}

      assert {:ok, %Balance{} = balance} = Transactions.update_balance(balance, update_attrs)
      assert balance.balance == 43
      assert balance.month == ~D[2022-03-27]
      assert balance.received == 43
      assert balance.sent == 43
    end

    test "update_balance/2 with invalid data returns error changeset" do
      balance = balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_balance(balance, @invalid_attrs)
      assert balance == Transactions.get_balance!(balance.id)
    end

    test "delete_balance/1 deletes the balance" do
      balance = balance_fixture()
      assert {:ok, %Balance{}} = Transactions.delete_balance(balance)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_balance!(balance.id) end
    end

    test "change_balance/1 returns a balance changeset" do
      balance = balance_fixture()
      assert %Ecto.Changeset{} = Transactions.change_balance(balance)
    end
  end
end
