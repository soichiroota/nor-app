module Api
    module V1
        class MicropostsController < ApplicationController
            def create
                @micropost = current_user.microposts.build(micropost_params)
                if @micropost.save
                    render json: { micropost: @micropost.to_json }
                else
                    render json: { micropost: nil, errors: @micropost.errors }
                end
            end

            def destroy
                if correct_user
                    @micropost.destroy
                    render json: { micropost: @micropost }
                else
                    render json: { micropost: nil }
                end
            end
        
            private
        
            def micropost_params
                params.require(:micropost).permit(:content, :picture)
            end

            def correct_user
                @micropost = current_user.microposts.find_by(id: params[:id])
                @micropost.nil? == false
            end
        end
    end
end
