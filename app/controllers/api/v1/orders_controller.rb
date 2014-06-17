module Api
  module V1
    class OrdersController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :user, :owner, :get_orders],
          :update => [:admin, :user, :owner, :update_orders],
          :destroy => [:admin, :user, :owner, :delete_orders]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_order, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]
      before_filter :update_order_state, :only => [:update]

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

      ################################################################################################################

      api :GET, '/orders', 'All the orders in the system'
      description "Fetches all the orders in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[orders], :index, format }

      def index
        @orders = Order.all
        respond_with @orders
      end

      ################################################################################################################

      api :GET, '/orders/:id', 'Get an order in the system'
      description "Fetches an order in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[orders], :show, format }

      def show
        respond_with @order
      end

      ################################################################################################################

      api :PUT, '/orders/:id', 'Update an order in the system'
      description "Updates an order in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param :state, ['open', 'cancelled'], :desc => 'Set the new state for the order.'
      FORMATS.each { |format| example BaseController.example_file %w[orders], :update, format }

      def update
        update_order @order
        respond_with @order
      end

      ################################################################################################################

      api :DELETE, '/orders/:id', 'Delete an order in the system'
      description "Deletes an order in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[orders], :destroy, format }

      def destroy
        render_forbidden 'not_new_state' and return if @order.state != :new
        @order.destroy
        respond_with @order
      end

      ################################################################################################################

      private

      def set_order
        @order = Order.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Order'
      end

      def check_ownership
        render_model_not_found 'Order' if not_admin_and?(!@user.owns(@order))
      end

      def update_order_state
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