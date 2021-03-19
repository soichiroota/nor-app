class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :authenticate!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    outcome = User::SignIn.run(params)
    if outcome.valid?
      @user = outcome.result
      if @user.activated?
        message = "User: #{@user.id} has successfully logged in."
        Rails.logger.info(message)

        render json: {
          token: @user.token,
          user: user_secure_column}
      else
        render json: {
          token: nil,
          user: user_secure_column}
      end
    else
      render json: { messages: outcome.errors.full_messages }, status: :unauthorized
    end
  end

  def token_current_user
    # ヘッダーのトークンに紐付いたuserを返す
    @user = current_user
    render json: { user: user_secure_column }
  end

  private

  def user_secure_column
    @user.as_json(except: [:created_at, :updated_at, :token, :password_digest])
  end
end
