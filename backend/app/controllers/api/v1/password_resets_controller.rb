module Api
  module V1
    class PasswordResetsController < ApplicationController
      skip_before_action :authenticate!, only: [:create, :update]
      skip_before_action :verify_authenticity_token, only: [:create, :update]
      before_action :get_user, only: [:update]

      def create
        @user = User.find_by(email: params[:password_reset][:email].downcase)
        if @user
          @user.create_reset_digest
          @user.send_password_reset_email(params[:password_reset][:url], true)
          render json: { user: secure_column(@user) }
        else
          render json: { user: nil }
        end
      end

      def update
        if !valid_user
          render json: { user: nil, errors: nil, token: nil }
        end
        if check_expiration
          render json: { user: nil, errors: ["Password reset has expired."], token: nil}
        end
        if params[:user][:password].empty?
          @user.errors.add(:password, :blank)
          render json: { user: nil, errors: @user.errors.full_messages, token: nil }
        elsif @user.update_attributes(user_params)
          @user.update_attribute(:reset_digest, nil)
          render json: { user: secure_column(@user), errors: nil, token: @user.token }
        else
          render json: { user: nil, errors: @user.errors.full_messages, token: nil }                                    
        end
      end

      private

      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end

      def secure_column(user)
        user.as_json(except: [:created_at, :updated_at, :token, :password_digest])
      end

      def get_user
        @user = User.find_by(email: params[:user][:email])
      end
  
      # 正しいユーザーかどうか確認する
      def valid_user
        unless (@user && @user.activated? &&
                @user.authenticated?(:reset, params[:id]))
          return false
        end
        return true
      end

      # トークンが期限切れかどうか確認する
      def check_expiration
        if @user.password_reset_expired?
          return true
        end
        return false
      end
    end
  end
end