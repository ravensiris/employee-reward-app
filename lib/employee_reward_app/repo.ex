defmodule EmployeeRewardApp.Repo do
  use Ecto.Repo,
    otp_app: :employee_reward_app,
    adapter: Ecto.Adapters.Postgres

  @dialyzer {:nowarn_function, rollback: 1}
end
