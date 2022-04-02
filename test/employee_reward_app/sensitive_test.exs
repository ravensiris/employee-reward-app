defmodule EmployeeRewardApp.SensitiveTest do
  use EmployeeRewardApp.DataCase
  import EmployeeRewardApp.Factory
  alias EmployeeRewardApp.Utils.Sensitive

  defp user_assert(u1_omit, u1, is_email_visible \\ false) do
    assert u1_omit.id == u1.id
    assert u1_omit.name == u1.name
    assert u1_omit.role == u1.role
    assert u1_omit.email == if(is_email_visible, do: u1.email, else: nil)
  end

  defp transaction_assert(
         t1_omit,
         t1,
         is_email_visible_from \\ false,
         is_email_visible_to \\ false
       ) do
    user_assert(t1.from_user, t1.from_user, is_email_visible_from)
    user_assert(t1.to_user, t1.to_user, is_email_visible_to)
  end

  describe "omit(%User{}, %User{})" do
    test "hides email from other member level users" do
      u1 = build(:user)
      u2 = build(:user, %{role: :member})
      u1_omit = Sensitive.omit(u1, u2)
      user_assert(u1_omit, u1)
    end

    test "shows email to self" do
      u1 = build(:user)
      u1_omit = Sensitive.omit(u1, u1)
      user_assert(u1_omit, u1, true)
    end

    test "shows email to admin level users" do
      u1 = build(:user)
      admin = build(:user, %{role: :admin})
      u1_omit = Sensitive.omit(u1, admin)
      user_assert(u1_omit, u1, true)
    end
  end

  describe "omit(%Transaction{}, %User{})" do
    test "hides sensitive user information from other member level users" do
      from_user = build(:user)
      to_user = build(:user)
      t1 = build(:transaction, %{from_user: from_user, to_user: to_user})
      t1_omit = Sensitive.omit(t1)
      transaction_assert(t1, t1_omit)
    end

    test "shows sensitive user information just to one side of transaction" do
      from_user = build(:user, %{role: :member})
      to_user = build(:user, %{role: :member})
      t1 = build(:transaction, %{from_user: from_user, to_user: to_user, amount: 1})
      t1_omit_to = Sensitive.omit(t1, from_user)
      t1_omit_from = Sensitive.omit(t1, to_user)

      transaction_assert(t1, t1_omit_to, true)
      transaction_assert(t1, t1_omit_from, false, true)
    end

    test "shows sensitive user information to admin level user" do
      from_user = build(:user)
      to_user = build(:user)
      admin = build(:user, %{role: :admin})
      t1 = build(:transaction, %{from_user: from_user, to_user: to_user, amount: 1})
      t1_omit = Sensitive.omit(t1, admin)

      transaction_assert(t1, t1_omit, true, true)
    end
  end
end
