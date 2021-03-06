module Api
  module V1
    class OrderItemsController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :user, :owner, :get_orders],
          :update => [:admin, :user, :owner, :update_orders],
          :destroy => [:admin, :user, :owner, :delete_orders]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_order_item, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]
      before_filter :update_order_item_state, :only => [:update]

      resource_description do
        name 'Order Items'
        short_description 'All about order items in the system'
        path '/order_items'
        description 'The Order Items endpoint lets you view and edit existing order items in the system.' +
                        'Only a user or staff member can view or manage order items.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/order_items', 'All the order items in the system'
      description "Fetches all the order items in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[order_items], :index, format }

      def index
        @order_items = OrderItem.all
        respond_with @order_items
      end

      ################################################################################################################

      api :GET, '/order_items/:id', 'Get an order item in the system'
      description "Gets an order item in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[order_items], :show, format }

      def show
        respond_with @order_item
      end

      ################################################################################################################

      api :PUT, '/order_items/:id', 'Update an order item in the system'
      description "Updates an order item in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_order_item, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[order_items], :update, format }

      def update
        @order_item = update_order_item @order_item
        respond_with @order_item
      end

      ################################################################################################################

      api :DELETE, '/order_items/:id', 'Delete an order item in the system'
      description "Deletes an order item in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[order_items], :destroy, format }

      def destroy
        render_forbidden 'not_new_state' and return if @order_item.order.state != :new
        @order_item.destroy
        respond_with @order_item
      end

      ################################################################################################################

      private

      def set_order_item
        @order_item = OrderItem.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'OrderItem'
      end

      def check_ownership
        render_model_not_found 'OrderItem' if not_admin_and?(!@user.owns(@order_item))
      end

      def update_order_item_state
        (render_bad_request [ 'state' ]; return) if @user.class == User && @user.type == 'User' && params[:state]
        @order_item.count = params[:count] || @order_item.count
        @order_item.comment = params[:comment] || @order_item.comment
        @order_item.save!
        @order_item.send "#{params[:state]}!".to_sym
      rescue NoMethodError
        render_bad_request [ 'state' ]
      end

    end
  end
end