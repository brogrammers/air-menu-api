module Api
  module V1
    class OrderItemsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :create, :scopes => [:admin, :user, :owner, :get_current_orders]
      doorkeeper_for :update, :scopes => [:admin, :user, :owner, :update_orders]

      before_filter :set_order_item, :only => [:show, :update]
      before_filter :check_ownership, :only => [:show, :update]
      before_filter :update_order_item, :only => [:update]
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

      api :GET, '/order_items', 'All the order items in the system'
      description 'Fetches all the order items in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/order_items/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/order_items/index.xml")
      def index
        @order_items = OrderItem.all
        respond_with @order_items
      end

      api :GET, '/order_items/:id', 'Get an order item in the system'
      description 'Gets an order item in the system. ||admin user owner get_current_orders||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/order_items/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/order_items/show.xml")
      def show
        respond_with @order_item
      end

      api :PUT, '/order_items/:id', 'Update an order item in the system'
      description 'Updates an order item in the system. ||admin user owner update_orders||'
      formats [:json, :xml]
      param :comment, String, :desc => 'Change comment for order item'
      param :count, Integer, :desc => 'Change the quantity of your order item'
      param :state, ['approved', 'declined', 'start_prepare', 'end_prepare', 'served'], :desc => 'Set the new state for the order item. (Only for staff members)'
      example File.read("#{Rails.root}/public/docs/api/v1/order_items/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/order_items/update.xml")
      def update
        respond_with @order_item
      end

      private

      def set_order_item
        @order_item = OrderItem.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'OrderItem'
      end

      def check_ownership
        render_model_not_found 'OrderItem' if not_admin_and?(!@user.owns(@order_item))
      end

      def update_order_item
        @order_item.comment = params[:comment] || @order_item.comment
        @order_item.count = params[:count] || @order_item.count
        @order_item.save!
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