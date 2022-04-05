defmodule EmployeeRewardApp.Users do
  @moduledoc false
  import Ecto.Query
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Repo

  @spec search_users(String.t()) :: [User.t()]
  @doc """
  Fuzzy search for a `User`.

  `term` is `User`'s `name` which is fuzzy matched
  `term` can search using `User`'s `id` after '@' symbol
  `term` can include both `User`'s `name` and `id` with '@' symbol between

  ## Examples
  search_users("john")
  [
    #EmployeeRewardApp.Users.User<
     ...
     email: "john.doe@example.org",
     id: "2db1d935-e5a5-4513-a247-5ccae2990ffc",
     name: "John Doe",
     role: :member,
     ...
    >,
    #EmployeeRewardApp.Users.User<
     ...
     email: "john.smith@example.org",
     id: "e9096aa8-7a53-481e-a310-08ffda9d21ab",
     name: "John Smith",
     role: :member,
     ...
    >,
    #EmployeeRewardApp.Users.User<
     ...
     email: "john.joe.smith@example.org",
     id: "47ae5412-a56d-43ec-91fd-3eeeddff637c",
     name: "John Joe Smith",
     role: :member,
     ...
    >
  ]

  search_users("john@e9")
  [
    #EmployeeRewardApp.Users.User<
     ...
     email: "john.smith@example.org",
     id: "e9096aa8-7a53-481e-a310-08ffda9d21ab",
     name: "John Smith",
     role: :member,
     ...
    >
  ]

  search_users("@e9")
  [
    #EmployeeRewardApp.Users.User<
     ...
     email: "john.smith@example.org",
     id: "e9096aa8-7a53-481e-a310-08ffda9d21ab",
     name: "John Smith",
     role: :member,
     ...
    >
  ]
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
        },
        # filter only active users
        where: not is_nil(u.email_confirmed_at)

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

  # TODO: doc + type
  def get_user(user_id) do
    Repo.get(User, user_id)
  end
end
