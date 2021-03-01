# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Test activation link is http://localhost:5000/account_activations/{activation_digest}/edit?email=example%40railstutorial.org&redirected=http%3A%2F%2Flocalhost%3A3000%2Fhome
  def account_activation
    user = User.first 
    user.activation_token = User.new_random_token
    redirected = "http://localhost:3000"
    UserMailer.account_activation(user, redirected, true)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end
