module Api
  module V1
    module Orders
      class OrderItemsController < BaseController
        SCOPES = {
            :index => [:admin, :user, :owner, :get_orders],
            :create => [:admin, :user, :owner, :add_orders]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_order, :only => [:index, :create]
        before_filter :set_menu_item, :only => [:create]
        before_filter :check_active_menu_item, :only => [:create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Orders > Order Items'
          short_description 'All about order items of orders'
          path '/orders/:id/order_items'
          description 'The Orders Order Items endpoint lets you create new order items for an order.' +
                          'Only a user or staff member can create order items.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/orders/:id/order_items', 'All the order items of an order'
        description "Fetches all the order items in of an order. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[orders order_items], :index, format }

        def index
          @order_items = @order.order_items
          respond_with @order_items
        end

        ################################################################################################################

        api :POST, '/orders/:id/order_items', 'Create an order item for an existing order'
        description "Creates an order item for an existing order. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_order_item, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[orders order_items], :create, format }

        def create
          @order_item = create_order_item @order, @menu_item
          respond_with @order_item, :status => :created
        end

        ################################################################################################################

        private

        def set_order
          @order = Order.find params[:order_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Order'
        end

        def set_menu_item
          @menu_item = MenuItem.find params[:menu_item_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'MenuItem'
        end

        def check_active_menu_item
          render_model_not_found 'MenuItem' if not_admin_and?(!@menu_item.active? && !@user.owns(@menu_item))
        end

        def check_ownership
          render_model_not_found 'Order' if not_admin_and?(!@user.owns(@order))
        end

      end
    end
  end
end