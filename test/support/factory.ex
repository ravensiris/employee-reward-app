defmodule EmployeeRewardApp.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: EmployeeRewardApp.Repo
  alias EmployeeRewardApp.Users.User

  def user_factory(attrs) do
    password = Map.get(attrs, :password, "arstarst")

    %User{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      role: sequence(:role, ["admin", "member"]),
      password: password
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end
end
