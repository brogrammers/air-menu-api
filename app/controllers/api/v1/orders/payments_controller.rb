module Api
  module V1
    module Orders
      class PaymentsController < BaseController
        SCOPES = {
            :create => [:admin, :user, :create_payments]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_order, :only => [:create]
        before_filter :set_credit_card, :only => [:create]
        before_filter :check_ownership, :only => [:create]

        resource_description do
          name 'Orders > Payments'
          short_description 'All about handling payments for orders'
          path '/orders/:id/payments'
          description 'The Orders Payments endpoint lets you pay for an order.' +
                          'Only a user or staff member can operate this endpoint.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :POST, '/orders/:id/payments', 'Create a payment for an unpaid existing order'
        description 'Creates a payment for an unpaid existing order. If the user is creating a payment, he needs to ' +
                        "specify a preregistered credit card. Staff members cannot supply a credit card ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_payment, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[orders payments], :create, format }

        def create
          @payment = create_payment @order, @credit_card
          respond_with @payment, :status => :created
        end

        ################################################################################################################

        private

        def set_order
          @order = Order.find params[:order_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Order'
        end

        def set_credit_card
          @credit_card = CreditCard.find params[:credit_card_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'CreditCard' if @user.class == User
        end

        def check_ownership
          render_model_not_found 'Order' and return if not_admin_and?(!@user.owns(@order))
          if @user.class == User
            render_model_not_found 'CreditCard' if not_admin_and?(!@user.owns(@credit_card))
          elsif @user.class == StaffMember
            @credit_card = nil
          end
        end

      end
    end
  end
end