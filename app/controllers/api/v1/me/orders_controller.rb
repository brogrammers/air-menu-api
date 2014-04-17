module Api
  module V1
    module Me
      class OrdersController < BaseController

        doorkeeper_for :index, :scopes => [:get_orders]

        before_filter :check_staff_member
        before_filter :get_orders

        resource_description do
          name 'Me > Orders'
          short_description 'All about the order of a currently logged-in staff member'
          path '/me/orders'
          description 'The Restaurant Devices endpoint lets you manage devices for a restaurants.' +
                          'Only a users with the right scope can create groups.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        api :GET, '/me/orders', 'All the orders of the currently logged-in staff member'
        description 'Fetches all the orders of the currently logged-in staff member. ||get_orders||'
        formats [:json, :xml]
        param :state, ['open', 'approved', 'cancelled', 'served', 'paid'], 'Get orders of certain state', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/me/orders/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/me/orders/index.xml")
        def index
          respond_with @orders
        end

        private

        def check_staff_member
          render_forbidden 'not_staff_member' if @user.class != StaffMember
        end

        def get_orders
          @orders = @user.send :"#{params[:state]}_orders"
        rescue NoMethodError
          render_bad_request ['state']
        end

      end
    end
  end
end