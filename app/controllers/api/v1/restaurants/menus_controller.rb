module Api
  module V1
    module Restaurants
      class MenusController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_menus],
            :create => [:admin, :owner, :add_menus, :add_active_menus]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

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

        ################################################################################################################

        api :GET, '/restaurants/:id/menus', 'All the menus of a restaurant'
        description "Fetches all the menus in the system. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants menus], :index, format }

        def index
          @menus = @restaurant.menus
          respond_with @menus
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/menus', 'Create a menu for a restaurant'
        description "Creates a menu for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_menu, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants menus], :create, format }
        def create
          @menu = Menu.new
          @menu.name = params[:name]
          @menu.save!
          @restaurant.menus << @menu
          if params[:active] and (scope_exists? 'add_active_menus' or scope_exists? 'owner')
            @restaurant.active_menu_id = @menu.id
            @restaurant.save!
          end
          respond_with @menu, :status => :created
        end

        ################################################################################################################

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