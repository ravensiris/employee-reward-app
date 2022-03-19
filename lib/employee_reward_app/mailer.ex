defmodule EmployeeRewardApp.Mailer do
  use Pow.Phoenix.Mailer
  use Swoosh.Mailer, otp_app: :employee_reward_app

  import Swoosh.Email

  require Logger

  alias EmployeeRewardAppWeb.Endpoint

  defp replace_example_com(text) do
    String.replace(text, "http://example.com", Endpoint.url())
  end

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    html = replace_example_com(html)
    text = replace_example_com(text)

    %Swoosh.Email{}
    |> to({"", user.email})
    |> from({"Employee Reward App", "noreply@#{Endpoint.host()}"})
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  @impl true
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
