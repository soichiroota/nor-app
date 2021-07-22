class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate

            redirect_to "#{ENV['CLIENT_URL']}/home"
        else
            render html: "Invalid activation link"
        end
    end
end
