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
      resources :menu_items, :only => [:index, :show, :update, :destroy]
      resources :order_items, :only => [:index, :show, :update, :destroy]
      resources :staff_kinds, :only => [:index, :show, :update, :destroy]
      resources :staff_members, :only => [:index, :show, :update, :destroy]
      resources :devices, :only => [:index, :show, :update, :destroy]
      resources :credit_cards, :only => [:index, :show, :update, :destroy]
      resources :webhooks, :only => [:index, :show, :update, :destroy]
      resources :opening_hours, :only => [:index, :show, :update, :destroy]
      resources :notifications, :only => [:update]

      resources :groups, :only => [:index, :show, :update, :destroy] do
        resources :staff_members, :controller => 'groups/staff_members', :only => [:index, :create]
      end

      resources :orders, :only => [:index, :show, :update, :destroy] do
        resources :order_items, :controller => 'orders/order_items', :only => [:index, :create]
        resources :payments, :controller => 'orders/payments', :only => [:create]
      end

      resources :menu_sections, :only => [:index, :show, :update, :destroy] do
        resources :menu_items, :controller => 'menu_sections/menu_items', :only => [:index, :create]
      end

      resources :menus, :only => [:index, :show, :update, :destroy] do
        resources :menu_sections, :controller => 'menus/menu_sections', :only => [:index, :create]
      end

      resources :companies, :only => [:index, :show, :update, :create, :destroy] do
        resources :restaurants, :controller => 'companies/restaurants', :only => [:index, :create]
      end

      resources :restaurants, :only => [:index, :show, :update, :destroy] do
        resources :menus, :controller => 'restaurants/menus', :only => [:index, :create]
        resources :orders, :controller => 'restaurants/orders', :only => [:index, :create]
        resources :staff_kinds, :controller => 'restaurants/staff_kinds', :only => [:index, :create]
        resources :staff_members, :controller => 'restaurants/staff_members', :only => [:index, :create]
        resources :groups, :controller => 'restaurants/groups', :only => [:index, :create]
        resources :devices, :controller => 'restaurants/devices', :only => [:index, :create]
        resources :reviews, :controller => 'restaurants/reviews', :only => [:index, :create]
        resources :webhooks, :controller => 'restaurants/webhooks', :only => [:index, :create]
        resources :opening_hours, :controller => 'restaurants/opening_hours', :only => [:index, :create]
      end

      resources :me, :only => [:index]
      put 'me', :to => 'me#update'
      namespace :me do
        resources :credit_cards, :controller => 'credit_cards', :only => [:index, :create]
        resources :devices, :controller => 'devices', :only => [:index, :create]
        resources :notifications, :controller => 'notifications', :only => [:index]
        resources :orders, :controller => 'orders', :only => [:index]
        resources :order_items, :controller => 'order_items', :only => [:index]
      end
    end

  end

end
