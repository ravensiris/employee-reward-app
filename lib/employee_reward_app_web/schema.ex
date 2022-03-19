defmodule EmployeeRewardAppWeb.Schema do
  use Absinthe.Schema

  query do
    field :test, :string do
      resolve(fn _, _, _ -> {:ok, "ok"} end)
    end
  end
end
