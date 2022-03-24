defmodule EmployeeRewardApp.Mailer do
  @moduledoc false
  use Pow.Phoenix.Mailer
  use Swoosh.Mailer, otp_app: :employee_reward_app

  import Swoosh.Email

  require Logger

  alias EmployeeRewardAppWeb.Endpoint

  @impl true
  @spec cast(%{
          :html => binary,
          :subject => binary,
          :text => binary,
          :user => atom | %{:email => any, optional(any) => any},
          optional(any) => any
        }) :: Swoosh.Email.t()
  @doc """
  Creates a user confirmation Swoosh.Email.t() from data supplied by Pow
  """
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    %Swoosh.Email{}
    |> to({"", user.email})
    |> from({"Employee Reward App", "noreply@#{Endpoint.host()}"})
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  @impl true
  @spec process(Swoosh.Email.t()) :: :ok
  @doc """
  Sends a user confirmation email asyncronously
  """
  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.

    Task.start(fn ->
      email
      |> deliver()
      |> log_warnings()
    end)

    :ok
  end

  defp log_warnings({:error, reason}) do
    Logger.warn("Mailer backend failed with: #{inspect(reason)}")
  end

  defp log_warnings({:ok, response}), do: {:ok, response}
end
