defmodule EmployeeRewardAppWeb.Schema do
  use Absinthe.Schema
  alias EmployeeRewardAppWeb.Schema

  import_types(Schema.Types.User)

  query do
    field :me, :user do
      resolve(fn _, _, %{context: context} ->
        user = Map.get(context, :current_user)

        case user do
          nil -> {:error, "user not logged in"}
          user -> {:ok, Map.take(user, [:id, :email, :role])}
        end
      end)
    end
  end
end
