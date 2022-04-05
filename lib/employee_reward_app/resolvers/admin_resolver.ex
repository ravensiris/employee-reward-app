defmodule EmployeeRewardApp.Resolvers.AdminResolver do
  alias EmployeeRewardApp.Users.User
  alias EmployeeRewardApp.Users
  alias EmployeeRewardApp.Transactions.Transaction
  alias EmployeeRewardApp.Transactions.Balance
  alias EmployeeRewardApp.Repo
  import Ecto.Query

  # TODO: move the queries to a context
  def summarized_month(_parent, %{month: month}, %{
        context: %{is_admin: true}
      }) do
    start_month = Timex.beginning_of_month(month)
    end_month = Timex.end_of_month(start_month)

    filter_date_transaction =
      from(t in Transaction,
        where: fragment("? BETWEEN ? AND ?", t.inserted_at, ^start_month, ^end_month)
      )
      |> subquery()

    sent =
      from(t in filter_date_transaction,
        select: %{user_id: t.from_user_id, sent: sum(t.amount)},
        group_by: t.from_user_id
      )

    received =
      from(t in filter_date_transaction,
        select: %{user_id: t.to_user_id, received: sum(t.amount)},
        group_by: t.to_user_id
      )

    summarized =
      from(u in User,
        left_join: s in subquery(sent),
        on: u.id == s.user_id,
        left_join: r in subquery(received),
        on: u.id == r.user_id,
        select_merge: %{
          balance: %{
            sent: coalesce(s.sent, 0),
            received: coalesce(r.received, 0),
            balance: 50 - coalesce(s.sent, 0) + coalesce(r.received, 0)
          }
        }
      )
      |> Repo.all()

    {:ok, summarized}
  end

  def summarized_month(_parent, _args, _info), do: {:error, "unauthorized"}

  # TODO: move the queries to a context
  def user_transactions(_parent, %{month: month, user_id: user_id}, %{context: %{is_admin: true}}) do
    start_month = Timex.beginning_of_month(month)
    end_month = Timex.end_of_month(start_month)

    transactions =
      from(t in Transaction,
        or_where: t.from_user_id == ^user_id,
        or_where: t.to_user_id == ^user_id,
        where: fragment("? BETWEEN ? AND ?", t.inserted_at, ^start_month, ^end_month),
        preload: [:from_user, :to_user]
      )
      |> Repo.all()

    {:ok, transactions}
  end

  def user_transactions(_parent, _args, _info), do: {:error, "unauthorized"}
end
