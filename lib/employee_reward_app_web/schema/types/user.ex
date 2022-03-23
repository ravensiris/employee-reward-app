defmodule EmployeeRewardAppWeb.Schema.Types.User do
  use Absinthe.Schema.Notation
  alias EmployeeRewardAppWeb.Schema

  import_types(Schema.Types.UUID4)

  object :user do
    field :id, :uuid4
    field :email, :string
    field :role, :string
  end
end
