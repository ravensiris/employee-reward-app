defmodule EmployeeRewardAppWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: EmployeeRewardAppWeb.Schema
  alias EmployeeRewardApp.Users

  @impl true
  def connect(%{"subscriptionToken" => token}, socket) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(EmployeeRewardAppWeb.Endpoint, "user subscription session", token,
             max_age: 86_400
           ),
         %Users.User{} = current_user <- Users.get_user(user_id) do
      socket =
        Absinthe.Phoenix.Socket.put_options(socket,
          context: %{
            current_user: current_user
          }
        )

      {:ok, socket}
    else
      _ -> :error
    end
  end

  def connect(_params, _socket), do: :error

  @impl true
  def id(_socket), do: nil
end
