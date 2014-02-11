module Api
  module V1
    class RestaurantMenusController < BaseController

      doorkeeper_for :index, :scopes => [:owner, :get_menus]
      doorkeeper_for :create, :scopes => [:owner, :add_menus, :add_active_menus]

      resource_description do
        name 'Restaurant Menus'
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
      description 'Fetches all the menus in the system. <b>Scopes:</b> owner get_menus'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.xml")
      def index
        @restaurant = Restaurant.find params[:restaurant_id]
        respond_with @restaurant.menus
      end

    end
  end
end