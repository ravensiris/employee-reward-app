defmodule EmployeeRewardAppWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias EmployeeRewardAppWeb.Schema
  alias EmployeeRewardAppWeb.Middleware
  alias EmployeeRewardApp.Resolvers

  import_types(Absinthe.Type.Custom)
  import_types(Schema.Types.UUID4)
  import_types(Schema.Types.BalanceType)
  import_types(Schema.Types.UserType)
  import_types(Schema.Types.TransactionType)

  @desc "Transaction direction relative to the user"
  enum :transaction_direction do
    value(:incoming, description: "Incoming transactions")
    value(:outgoing, description: "Outgoing transactions")
  end

  query do
    @desc "Get current user"
    field :me, :user do
      middleware(Middleware.Authentication)
      resolve(&Resolvers.MeResolver.show_me/3)
    end

    @desc "Lists 10 recent transactions"
    field :transactions, list_of(:transaction) do
      middleware(Middleware.Authentication)
      arg(:direction, :transaction_direction)
      resolve(&Resolvers.TransactionResolver.get_recent/3)
    end

    @desc "Find user by name with fuzzy search"
    field :users, list_of(:user) do
      middleware(Middleware.Authentication)
      arg(:name, non_null(:string))
      resolve(&Resolvers.UserResolver.search_user/3)
    end

    @desc "ADMIN ONLY: get summary of a month"
    field :summarized_month, list_of(:user) do
      middleware(Middleware.Authentication)
      arg(:month, non_null(:naive_datetime))
      resolve(&Resolvers.AdminResolver.summarized_month/3)
    end

    @desc "ADMIN ONLY: get user's transactions for a month"
    field :user_transactions, list_of(:transaction) do
      middleware(Middleware.Authentication)
      arg(:month, non_null(:naive_datetime))
      arg(:user_id, non_null(:uuid4))
      resolve(&Resolvers.AdminResolver.user_transactions/3)
    end
  end

  mutation do
    @desc "Send credits to another user"
    field :transaction, type: :transaction do
      middleware(Middleware.Authentication)
      arg(:amount, non_null(:integer))
      arg(:to, non_null(:uuid4))

      resolve(&Resolvers.TransactionResolver.send_credits/3)
    end

    @desc "ADMIN ONLY: Delete given transaction"
    field :delete_transaction, :transaction do
      middleware(Middleware.Authentication)
      arg(:transaction_id, non_null(:uuid4))
      resolve(&Resolvers.AdminResolver.delete_transaction/3)
    end
  end

  subscription do
    @desc "Announces new transactions"
    field :new_transaction, :transaction do
      arg(:direction, non_null(:transaction_direction))

      config(fn
        args, %{context: %{current_user: %{id: user_id}}} ->
          {:ok, topic: "#{args.direction}_transaction:#{user_id}"}

        _args, _info ->
          {:error, "user unauthorized"}
      end)
    end

    @desc "Announces changes in balance"
    field :update_balance, :balance do
      config(fn
        _args, %{context: %{current_user: %{id: user_id}}} ->
          {:ok, topic: "balance:#{user_id}"}

        _args, _info ->
          {:error, "user unauthorized"}
      end)
    end
  end
end
