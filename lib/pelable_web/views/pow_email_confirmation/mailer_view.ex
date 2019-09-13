defmodule PelableWeb.PowEmailConfirmation.MailerView do
  use PelableWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
