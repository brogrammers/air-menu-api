module Api
  module V1
    class OrdersController < BaseController

      before_filter :set_order, :only => [:show, :update]
      before_filter :check_ownership, :only => [:show, :update]
      before_filter :update_order, :only => [:update]

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :user, :owner, :get_orders]
      doorkeeper_for :update, :scopes => [:admin, :user, :owner, :update_orders]

      resource_description do
        name 'Orders'
        short_description 'All about the orders in the system'
        path '/orders'
        description 'The Orders endpoint lets you view & update orders in the system.' +
                        'Only Users, Owners & staff members with appropriate scope can only see their orders.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/orders', 'All the orders in the system'
      description 'Fetches all the orders in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/orders/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/orders/index.xml")
      def index
        @orders = Order.all
        respond_with @orders
      end

      api :GET, '/orders/:id', 'Get an order in the system'
      description 'Fetches an order in the system. ||admin user owner get_orders||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/orders/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/orders/show.xml")
      def show
        respond_with @order
      end

      api :PUT, '/orders/:id', 'Update an order in the system'
      description 'Updates an order in the system. ||admin user owner update_orders||'
      formats [:json, :xml]
      param :state, ['open', 'cancelled'], :desc => 'Set the new state for the order.'
      example File.read("#{Rails.root}/public/docs/api/v1/orders/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/orders/show.xml")
      def update
        respond_with @order
      end

      private

      def set_order
        @order = Order.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Order'
      end

      def check_ownership
        render_model_not_found 'Order' if not_admin_and?(!@user.owns(@order))
      end

      def update_order
        if params[:state] == 'cancelled' or params[:state] == 'open'
          @order.send "#{params[:state]}!".to_sym
        else
          render_bad_request [ 'state' ]
        end
      rescue NoMethodError
        render_bad_request [ 'state' ]
      end

    end
  end
end