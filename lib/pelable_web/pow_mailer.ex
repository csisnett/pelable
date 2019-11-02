defmodule PelableWeb.PowMailer do
    use Pow.Phoenix.Mailer
    use Swoosh.Mailer, otp_app: :pow
  
    import Swoosh.Email
    
    require Logger
  
    def cast(%{user: user, subject: subject, text: text, html: html}) do
      %Swoosh.Email{}
      |> to({user.username, user.email})
      |> from({"Carlos from Pelable", "carlos@pelable.com"})
      |> subject(subject)
      |> html_body(html)
      |> text_body(text)
    end

    def send_admin(%{"subject" => subject, "text" => text, "html" => html}) do
      %Swoosh.Email{}
      |> to({"pelable_bot", "carlos@pelable.com"})
      |> from({"Carlos from Pelable", "carlos@pelable.com"})
      |> subject(subject)
      |> html_body(html)
      |> text_body(text)
      |> process
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