module Api
  module V1
    module Restaurants
      class OrdersController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_current_orders],
            :create => [:admin, :user, :owner, :add_orders]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_can_make_order, :only => [:create]
        before_filter :check_ownership, :only => [:index]

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

        ################################################################################################################

        api :GET, '/restaurants/:id/orders', 'All the current orders of a restaurant'
        description "Fetches all the current orders in of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants orders], :index, format }

        def index
          @orders = @restaurant.current_orders
          respond_with @orders
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/orders', 'Create an order for a restaurant'
        description "Creates an order for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_order, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants orders], :create, format }

        def create
          @order = create_order @restaurant
          respond_with @order, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_can_make_order
          render_forbidden 'different_restaurant' if @user.class == StaffMember && !@user.owns(@restaurant)
          render_forbidden 'too_many_orders' if not_admin_and?(!@user.owns(@restaurant) && !@user.can_order?)
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end