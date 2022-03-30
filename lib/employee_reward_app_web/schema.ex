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

    # TODO: Tests
    # TODO: Desc
    # BUG: Leaks emails and possibly other info to non admin users
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
end
