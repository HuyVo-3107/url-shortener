Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope :auth do
    post '/register', to: "authentication#register"
    post '/login', to: "authentication#login"
    post '/refresh_token', to: "authentication#refresh_token"
  end

  namespace :api do
    get '/', to: "api#index"
  end
end
