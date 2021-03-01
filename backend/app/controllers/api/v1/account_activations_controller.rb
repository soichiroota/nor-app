module Api
    module V1
        class AccountActivationsController < Api::V1::ApplicationController
            skip_before_action :authenticate!, only: [:edit]
            skip_before_action :verify_authenticity_token, only: [:edit]

            def edit
                user = User.find_by(email: params[:email])
                if user && !user.activated? && user.authenticated?(:activation, params[:id])
                    user.activate
                    user.token_refresh!
                    user.reload

                    render json: {
                        user: secure_column(user),
                        token: user.token
                    }
                else
                    render json: {
                        user: nil,
                        token: nil
                    }
                end
            end

            private

            def secure_column(user)
              user.as_json(except: [:created_at, :updated_at, :token, :password_digest])
            end
        end
    end
end
