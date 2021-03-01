class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user, url, is_base_url)
    @user = user
    if is_base_url
      @activation_url = "#{url}/accountActivations/#{user.email}/#{user.activation_token}/edit"
    else
      @activation_url = edit_account_activation_url(user.activation_token, email: user.email, redirected: url)
    end
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
