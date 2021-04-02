module Api
    module V1
        class RelationshipsController < ApplicationController
            def create
                user = User.find(params[:followed_id])
                current_user.follow(user)
                render json: { user: user.to_json }
            end
            
            def destroy
                user = Relationship.find(params[:id]).followed
                current_user.unfollow(user)
                render json: { user: user.to_json }
            end
        end
    end
end
