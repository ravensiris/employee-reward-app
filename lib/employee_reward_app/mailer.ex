defmodule EmployeeRewardApp.Mailer do
  @moduledoc false
  use Pow.Phoenix.Mailer
  use Swoosh.Mailer, otp_app: :employee_reward_app

  import Swoosh.Email

  require Logger

  alias EmployeeRewardAppWeb.Endpoint
  alias EmployeeRewardApp.Transactions.Transaction
  alias EmployeeRewardApp.Users.User

  @impl true
  @type pow_email_map() :: %{
          :html => binary,
          :subject => binary,
          :text => binary,
          :user => atom | %{:email => any, optional(any) => any},
          optional(any) => any
        }
  @spec cast(pow_email_map() | Transaction.t()) :: Swoosh.Email.t()
  @doc """
  Converts supported maps/structs to `Swoosh.Email`
  """
  def cast(%{user: %User{name: name, email: email}, subject: subject, text: text, html: html}) do
    %Swoosh.Email{}
    |> to({name, email})
    |> from()
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  def cast(%Transaction{to_user: %User{name: name, email: email}, amount: amount}) do
    %Swoosh.Email{}
    |> to({name, email})
    |> from()
    |> subject("You have been awarded #{amount}Ψ!")
    |> text_body("""
    You have been awarded #{amount}Ψ!
    Your efforts have been acknowledged!
    All the best,
    EmployeeRewardApp Team
    """)
  end

  @impl true
  @spec process(Swoosh.Email.t()) :: :ok
  @doc """
  Sends emails asynchronously
  """
  def process(email) do
    Task.Supervisor.start_child(
      EmployeeRewardApp.AsyncEmailSupervisor,
      fn ->
        email
        |> deliver()
        |> log_warnings()
      end
    )

    :ok
  end

  defp log_warnings({:error, reason}) do
    Logger.warn("Mailer backend failed with: #{inspect(reason)}")
  end

  defp log_warnings({:ok, response}), do: {:ok, response}

  defp from(mail) do
    mail
    |> from({"Employee Reward App", "employeerewardapp@protonmail.com"})
  end
end
