defmodule EmployeeRewardAppWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias EmployeeRewardAppWeb.Schema
  alias EmployeeRewardAppWeb.Middleware
  alias EmployeeRewardApp.Resolvers

  import_types(Schema.Types.UUID4)
  import_types(Schema.Types.BalanceType)
  import_types(Schema.Types.UserType)
  import_types(Schema.Types.TransactionType)

  query do
    @desc "Get current user"
    field :me, :user do
      middleware(Middleware.Authentication)
      resolve(&Resolvers.MeResolver.show_me/3)
    end

    @desc "Lists 10 recent transactions"
    field :transactions, list_of(:transaction) do
      middleware(Middleware.Authentication)
      resolve(&Resolvers.TransactionResolver.get_recent/3)
    end

    @desc "Find user by name with fuzzy search"
    field :users, list_of(:user) do
      middleware(Middleware.Authentication)
      arg(:name, non_null(:string))
      resolve(&Resolvers.UserResolver.search_user/3)
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
  end

  @desc "Transaction direction relative to the user"
  enum :transaction_direction do
    value(:incoming, description: "Incoming transactions")
    value(:outgoing, description: "Outgoing transactions")
  end

  subscription do
    field :new_transaction, :transaction do
      arg(:direction, non_null(:transaction_direction))

      config(fn args, _info ->
        # TODO: add token arg and replace user id that token belongs to
        # REFERENCE: https://github.com/danschultzer/pow/issues/153#issuecomment-478251934
        {:ok, topic: "#{args.direction}_transaction:*"}
      end)
    end
  end
end
