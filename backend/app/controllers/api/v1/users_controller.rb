module Api
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])
        render json: @user.to_json
      end

      def create
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
    end
  end
end
