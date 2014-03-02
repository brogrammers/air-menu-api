module Api
  module V1
    class OrdersController < BaseController

      before_filter :set_order, :only => [:show, :update]
      before_filter :check_ownership, :only => [:show, :update]

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :user, :owner, :get_orders]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_orders]

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
      description 'Updates an order in the system. ||admin owner update_orders||'
      formats [:json, :xml]
      param :prepared, [true, false], :desc => 'Set as prepared. This action is irreversible.'
      param :active, [true, false], :desc => 'Set as served. This action is irreversible.'
      example File.read("#{Rails.root}/public/docs/api/v1/orders/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/orders/show.xml")
      def update
        update_order
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
        if params[:served] and !@order.served and @order.prepared and @order.start and @user.owns @order
          @order.served = params[:served]
          @order.end_served = DateTime.now
        end
        if params[:prepared] and !@order.prepared and !@order.served and @order.start and @user.owns @order
          @order.prepared = params[:prepared]
          @order.end_prepared = DateTime.now
        end
        @order.save!
      end

    end
  end
end