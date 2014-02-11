AirMenuApi::Application.routes.draw do
  apipie

  namespace :api do
    use_doorkeeper do
      skip_controllers :authorizations, :tokens, :applications, :authorized_applications
    end

    namespace :oauth2 do
      resources :applications, :only => [:index, :show, :create]
      resources :access_tokens, :only => [:create]
    end

    namespace :v1 do
      resources :users, :only => [:index, :show, :create]
      resources :menus, :only => [:index, :show]

      resources :companies, :only => [:index, :show, :create] do
        resources :restaurants, :controller => 'company_restaurants', :only => [:index, :create]
      end

      resources :restaurants, :only => [:index, :show] do
        resources :menus, :controller => 'restaurant_menus', :only => [:index, :create]
      end

      get '/me', :to => 'me#index'
    end

  end

end
