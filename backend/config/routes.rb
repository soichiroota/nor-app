Rails.application.routes.draw do
  get 'users/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :tasks, only: :index
      get :health_check, to: 'health_check#index'
      post '/signup',  to: 'users#create'
      resources :users
    end
  end
end
