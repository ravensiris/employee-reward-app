defmodule EmployeeRewardApp.Users do
  @moduledoc false
  import Ecto.Query
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Repo

  @spec search_users(String.t()) :: [User.t()]
  @doc """
  Fuzzy search for a User.

  `term` is User's name.

  Returns a list of matching Users
  """
  def search_users(term) do
    name = term

    data_query =
      from u in User,
        select: %{
          id: u.id,
          name: u.name,
          email: u.email,
          name_clipped: fragment("SUBSTR(?, 0, LENGTH(?) + 1)", u.name, ^name)
        }

    from(
      u in subquery(data_query),
      order_by: fragment("LEVENSHTEIN(?, ?)", u.name_clipped, ^name),
      limit: 5
    )
    |> Repo.all()
  end
end
