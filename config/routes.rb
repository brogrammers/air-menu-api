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
      resources :menu_items, :only => [:index, :show]
      resources :order_items, :only => [:index, :show, :update]
      resources :staff_kinds, :only => [:index, :show]
      resources :staff_members, :only => [:index, :show]

      resources :orders, :only => [:index, :show, :update] do
        resources :order_items, :controller => 'order_order_items', :only => [:index, :create]
      end

      resources :menu_sections, :only => [:index, :show] do
        resources :menu_items, :controller => 'menu_section_menu_items', :only => [:index, :create]
      end

      resources :menus, :only => [:index, :show] do
        resources :menu_sections, :controller => 'menu_menu_sections', :only => [:index, :create]
      end

      resources :companies, :only => [:index, :show, :create] do
        resources :restaurants, :controller => 'company_restaurants', :only => [:index, :create]
      end

      resources :restaurants, :only => [:index, :show] do
        resources :menus, :controller => 'restaurant_menus', :only => [:index, :create]
        resources :orders, :controller => 'restaurant_orders', :only => [:index, :create]
        resources :staff_kinds, :controller => 'restaurant_staff_kinds', :only => [:index, :create]
        resources :staff_members, :controller => 'restaurant_staff_members', :only => [:index, :create]
      end

      get '/me', :to => 'me#index'
    end

  end

end
