module Api
  module V1
    module Orders
      class OrderItemsController < BaseController

        doorkeeper_for :index, :scopes => [:admin, :user, :owner, :get_orders]
        doorkeeper_for :create, :scopes => [:admin, :user, :owner, :add_orders]

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

        api :GET, '/orders/:id/order_items', 'All the order items of an order'
        description 'Fetches all the order items in of an order. ||admin user owner get_orders||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/orders/order_items/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/orders/order_items/index.xml")
        def index
          @order_items = @order.order_items
          respond_with @order_items
        end

        api :POST, '/orders/:id/order_items', 'Create an order item for an existing order'
        description 'Creates an order item for an existing order. ||admin user owner add_orders||'
        formats [:json, :xml]
        param :comment, String, :desc => 'Set a comment on the order item'
        param :count, Integer, :desc => 'Set how many times you want to order the menu item'
        param :menu_item_id, Integer, :desc => 'Set menu item'
        example File.read("#{Rails.root}/public/docs/api/v1/orders/order_items/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/orders/order_items/create.xml")
        def create
          @order_item = create_order_item @order, @menu_item
          respond_with @order_item, :status => :created
        end

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