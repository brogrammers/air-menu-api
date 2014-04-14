module Api
  module V1
    module Restaurants
      class MenusController < BaseController

        doorkeeper_for :index, :scopes => [:admin, :owner, :get_menus]
        doorkeeper_for :create, :scopes => [:admin, :owner, :add_menus, :add_active_menus]

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Restaurants > Menus'
          short_description 'All about menus of restaurants'
          path '/restaurants/:id/menus'
          description 'The Restaurant Menus endpoint lets you create new menus for a restaurant.' +
                          'Only an owner can create restaurants.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        api :GET, '/restaurants/:id/menus', 'All the menus of a restaurant'
        description 'Fetches all the menus in the system. ||admin owner get_menus||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/menus/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/menus/index.xml")
        def index
          @menus = @restaurant.menus
          respond_with @menus
        end

        api :POST, '/restaurants/:id/menus', 'Create a menu for a restaurant'
        description 'Creates a menu for a restaurant. ||admin owner add_menus add_active_menus||'
        formats [:json, :xml]
        param :name, String, :desc => 'Menu name', :required => true
        param :active, String, :desc => 'Make menu active. ||owner add_active_menus||'
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/menus/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/menus/create.xml")
        def create
          @menu = Menu.new
          @menu.name = params[:name]
          @menu.save!
          @restaurant.menus << @menu
          if params[:active] and scope_exists? 'add_active_menus' and scope_exists? 'owner'
            @restaurant.active_menu_id = @menu.id
            @restaurant.save!
          end
          respond_with @menu, :status => :created
        end

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end