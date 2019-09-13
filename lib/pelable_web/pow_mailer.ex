defmodule PelableWeb.PowMailer do
    use Pow.Phoenix.Mailer
    use Swoosh.Mailer, otp_app: :pow
  
    import Swoosh.Email
    
    require Logger
  
    def cast(%{user: user, subject: subject, text: text, html: html}) do
      %Swoosh.Email{}
      |> to({"", user.email})
      |> from({"My App", "myapp@example.com"})
      |> subject(subject)
      |> html_body(html)
      |> text_body(text)
    end
  
    def process(email) do
      email
      |> deliver()
      |> log_warnings()
    end
  
    defp log_warnings({:error, reason}) do
      Logger.warn("Mailer backend failed with: #{inspect(reason)}")
    end
  
    defp log_warnings({:ok, response}), do: {:ok, response}
  end