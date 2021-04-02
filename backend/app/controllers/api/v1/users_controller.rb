module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate!, only: [:show, :create]
      skip_before_action :verify_authenticity_token, only: [:show, :create]
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        authorize User
        @users = User.paginate(page: params[:page], per_page: 30)
        render json: { users: @users.to_json, pages: @users.total_pages }
      end

      def show
        @microposts = @user.microposts.paginate(page: params[:page])
        render json: { 
          user: @user.to_json(
            :methods => [:microposts_count, :following_count, :followers_count],
            :include => { 
              :following => { :only => :id },
              :followers => { :only => :id },
              :passive_relationships => { :only => [:id, :followed_id, :follower_id] }
            }
          ),
          microposts: @microposts.to_json,
          pages: @microposts.total_pages
        }
      end

      def create
        @user = User.new(user_params)
        if @user.save
          @user.send_activation_email(params[:url], true)
          render json: @user.to_json
        else
          render json: { errors: @user.errors.full_messages }
        end
      end

      def update
        authorize @user
        if @user.update_attributes(user_params)
          render json: @user.to_json
        else
          render json: { errors: @user.errors.full_messages }
        end
      end

      def destroy
        authorize @user
        render json: { status: :unprocessable_entity } unless current_user.admin?
        @user.destroy
        render json: @user.to_json 
      end

      def following
        @user  = User.find(params[:id])
        @users = @user.following.paginate(page: params[:page])
        render json: {
          user: @user.to_json(
            :methods => [:microposts_count]
          ),
          users: @users.to_json,
          pages: @users.total_pages
        }
      end
    
      def followers
        @user  = User.find(params[:id])
        @users = @user.followers.paginate(page: params[:page])
        render json: {
          user: @user.to_json(
            :methods => [:microposts_count]
          ),
          users: @users.to_json,
          pages: @users.total_pages
        }
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
