defmodule EmployeeRewardApp.Users do
  @moduledoc false
  import Ecto.Query
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Repo

  @spec search_users(String.t()) :: [User.t()]
  @doc """
  Fuzzy search for a User.

  `term` is User's name, User's id or both

  Returns a list of matching Users
  """
  def search_users(term) do
    start_character = String.slice(term, 0..1)

    from(
      u in User,
      # 2x where since term can start with either id or name
      where: ilike(u.name, ^"#{start_character}%"),
      or_where: ilike(type(u.id, :string), ^"#{start_character}%"),
      # 2x where since term can start with either id or name
      where:
        fragment(
          "SIMILARITY(?, ?) > 0",
          u.name,
          ^term
        ),
      or_where:
        fragment(
          "SIMILARITY(?, ?) > 0",
          type(u.id, :string),
          ^term
        ),
      order_by: fragment("LEVENSHTEIN(CONCAT(?, ?), ?) DESC", u.name, u.id, ^term),
      limit: 5
    )
    |> Repo.all()
  end
end
