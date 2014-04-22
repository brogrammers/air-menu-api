module Api
  module V1
    module Me
      class OrderItemsController < BaseController
        SCOPES = {
            :index => [:get_orders]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :check_staff_member
        before_filter :set_order_items

        resource_description do
          name 'Me > Order Items'
          short_description 'All about the order items of a currently logged-in staff member'
          path '/me/order_items'
          description 'The Restaurant Order Items endpoint lets you view current orders of a staff member.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/me/order_items', 'All the order items of the currently logged-in staff member'
        description "Fetches all the order items of the currently logged-in staff member. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        param :state, %w[open approved declined start_prepare end_prepare served], 'Get order items of certain state', :required => true
        FORMATS.each { |format| example BaseController.example_file %w[me order_items], :index, format }

        def index
          respond_with @order_items
        end

        ################################################################################################################

        private

        def check_staff_member
          render_forbidden 'not_staff_member' if @user.class != StaffMember
        end

        def set_order_items
          @order_items = @user.send :"#{params[:state]}_order_items"
        rescue NoMethodError
          render_bad_request ['state']
        end

      end
    end
  end
end