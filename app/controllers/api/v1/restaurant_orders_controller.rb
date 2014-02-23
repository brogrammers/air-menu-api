module Api
  module V1
    class RestaurantOrdersController < BaseController

      before_filter :set_restaurant, :only => [:index, :create]
      before_filter :check_can_make_order, :only => [:create]
      before_filter :check_ownership, :only => [:index]

      doorkeeper_for :index, :scopes => [:owner, :get_current_orders]
      doorkeeper_for :create, :scopes => [:user, :owner, :add_orders]

      resource_description do
        name 'Restaurants > Orders'
        short_description 'All about orders of restaurants'
        path '/restaurants/:id/orders'
        description 'The Restaurant Orders endpoint lets you create new orders for a restaurant and user.' +
                        'Only a user can create restaurants.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/restaurants/:id/orders', 'All the current orders of a restaurant'
      description 'Fetches all the current orders in of a restaurant. ||owner get_current_orders||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_orders/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_orders/index.xml")
      def index
        @orders = @restaurant.current_orders
        respond_with @orders
      end

      api :POST, '/restaurants/:id/orders', 'Create an order for a restaurant'
      description 'Creates an order for a restaurant. ||user owner add_orders||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_orders/create.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_orders/create.xml")
      def create
        @order = create_order @restaurant
        respond_with @order
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find params[:restaurant_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Restaurant'
      end

      def check_ownership
        # TODO: Add StaffMember check, if it owns restaurant for CREATE too, once StaffMembers exist!!
        # different treatment required for normal user than from StaffMember
        render_forbidden if !@user.owns @restaurant and !scope_exists? 'admin'
      end

      def check_can_make_order
        render_forbidden if !@user.owns @restaurant and !@user.can_order?
      end

    end
  end
end