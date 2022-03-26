defmodule EmployeeRewardApp.Users do
  @moduledoc false
  import Ecto.Query
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Repo

  @spec search_users(String.t()) :: [User.t()]
  @doc """
  Fuzzy search for a User.

  `term` is User's name.
  `term` can include User's id after '@' symbol
  `term` can be just User's id if begins with '@' symbol

  Returns a list of matching Users
  """
  def search_users(term) do
    [name | rest] = String.split(term, "@")
    id = List.last(rest) || ""
    name_prefix = String.slice(name, 0..1)
    id_prefix = String.slice(id, 0..1)

    data_query =
      from u in User,
        select: %{
          id: u.id,
          name_clipped: fragment("SUBSTR(?, 0, LENGTH(?) + 1)", u.name, ^name),
          id_prefix: fragment("SPLIT_PART(?, '-', 1)", type(u.id, :string))
        }

    from(
      u in User,
      join: d in subquery(data_query),
      on: d.id == u.id,
      where: ilike(u.name, ^"#{name_prefix}%"),
      where: ilike(d.id_prefix, ^"#{id_prefix}%"),
      order_by:
        fragment("LEVENSHTEIN(?, ?) + LEVENSHTEIN(?, ?)", d.name_clipped, ^name, d.id_prefix, ^id),
      limit: 5
    )
    |> Repo.all()
  end
end
