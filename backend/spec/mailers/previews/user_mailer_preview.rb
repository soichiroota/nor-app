# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Test activation link is http://localhost:5000/account_activations/{activation_digest}/edit?email=example%40railstutorial.org
  def account_activation
    user = User.first 
    user.activation_token = User.new_random_token
    redirected = "#{ENV['CLIENT_URL']}/home"
    UserMailer.account_activation(user, redirected, true)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  # Test reset link is http://localhost:3000/passwordResets/example%40railstutorial.org/{reset_digest}/edit
  def password_reset
    user = User.first
    user.reset_token = User.new_random_token
    redirected = "http://localhost:3000"
    UserMailer.password_reset(user, redirected, true)
  end

end
