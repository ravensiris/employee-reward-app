defmodule EmployeeRewardApp.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: EmployeeRewardApp.Repo
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Transactions.Transaction

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

  def transaction_factory do
    now = Timex.now()
    begin_month = Timex.beginning_of_month(now)
    end_month = Timex.end_of_month(now)

    inserted_at = Faker.DateTime.between(begin_month, end_month)

    %Transaction{
      amount: Enum.random(1..50),
      from_user: build(:user),
      to_user: build(:user),
      status: sequence(:status, [:active, :cancelled]),
      inserted_at: inserted_at,
      updated_at: inserted_at
    }
  end
end
