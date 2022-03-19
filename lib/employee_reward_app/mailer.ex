defmodule EmployeeRewardApp.Mailer do
  use Swoosh.Mailer, otp_app: :employee_reward_app
  require Logger
  import Swoosh.Email

  def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
    # Build email struct to be used in `process/1`
    new()
    |> from("noreply@secret-dawn-99555.herokuapp.com")
    |> to(user.email)
    |> subject(subject)
    |> text_body(text)
    |> html_body(html)
  end

  def process(email) do
    # Send email

    deliver!(email)
    Logger.debug("E-mail sent: #{inspect(email)}")
  end
end
