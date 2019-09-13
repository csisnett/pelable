defmodule PelableWeb.PowResetPassword.MailerView do
  use PelableWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
