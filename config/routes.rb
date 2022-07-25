Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope :auth do
    post '/register', to: "authentication#register"
    post '/login', to: "authentication#login"
    post '/refresh_token', to: "authentication#refresh_token"
  end

  namespace :api do
    get '/', to: "api#index"
    resources :links, except: %i[new edit], param: :short_url do
      member do
        get '/get_url', to: 'links#get_url'
      end
    end

    scope :user do
      put '/', to: "user#update"
      get '/user_info', to: "user#user_info"
      post '/generate_api_token', to: "user#generate_api_token"
      post '/change_pw', to: "user#change_pw"
    end
  end
end
