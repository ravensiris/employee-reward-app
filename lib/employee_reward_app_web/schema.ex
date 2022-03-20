defmodule EmployeeRewardAppWeb.Schema do
  use Absinthe.Schema
  alias EmployeeRewardAppWeb.Schema

  import_types(Schema.Types.UUID4)

  object :user do
    field :id, :uuid4
    field :email, :string
    field :name, :string
  end

  query do
    field :test, :user do
      resolve(fn _, _, %{context: context} ->
        user = Map.get(context, :current_user)

        case user do
          nil -> {:error, "user not logged in"}
          user -> {:ok, Map.take(user, [:id, :email, :name])}
        end
      end)
    end
  end
end
