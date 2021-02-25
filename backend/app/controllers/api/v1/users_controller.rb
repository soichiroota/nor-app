module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show]

      def show
        authorize @user
        render json: @user.to_json
      end

      def create
        authorize User
        @user = User.new(user_params)
        if @user.save
          render json: @user.to_json
        else
          render json: { errors: @user.errors.full_messages }
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
