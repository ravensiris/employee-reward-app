defmodule EmployeeRewardApp.Utils.Sensitive do
  @moduledoc """
  Module encompasses a bunch of helper functions to remove sensitive info from structs
  """
  alias EmployeeRewardApp.Users.User

  # TODO: spec and doc
  def omit_sensitive(any) do
    omit_sensitive(any, %User{})
  end

  def omit_sensitive(any, %User{role: :admin}) do
    any
  end

  def omit_sensitive(%User{} = user, %User{id: id}) do
    u = %User{
      id: user.id,
      name: user.name,
      role: user.role
    }

    # User has more access to his own data
    u =
      if user.id == id do
        %User{u | email: user.email}
      else
        u
      end

    u
  end
end
