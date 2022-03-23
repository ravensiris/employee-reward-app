defmodule EmployeeRewardAppWeb.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias EmployeeRewardAppWeb.Schema
  alias EmployeeRewardApp.Resolvers

  import_types(Schema.Types.User)

  query do
    field :me, :user do
      resolve(&Resolvers.Me.show_me/3)
    end
  end
end
