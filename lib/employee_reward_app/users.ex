defmodule EmployeeRewardApp.Users do
  @moduledoc false
  import Ecto.Query
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Repo

  @spec search_users(String.t()) :: [User.t()]
  def search_users(name) do
    start_character = String.slice(name, 0..1)

    from(
      u in User,
      where: ilike(u.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0", u.name, ^name),
      order_by: fragment("LEVENSHTEIN(?, ?)", u.name, ^name),
      limit: 5
    )
    |> Repo.all()
  end
end
