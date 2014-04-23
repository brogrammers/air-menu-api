module Api
  module V1
    class CreditCardsController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :user],
          :update => [:admin, :user],
          :destroy => [:admin, :user]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_credit_card, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]

      resource_description do
        name 'Credit Cards'
        short_description 'All about credit cards in the system'
        path '/devices'
        description 'The Credit Cards endpoint lets you manage credit cards in the system.' +
                        'Only a users with the right scope can manage credit cards.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/credit_cards', 'All the credit cards in the system'
      description "Fetches all the credit cards in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[credit_cards], :index, format }

      def index
        @credit_cards = CreditCard.all
        respond_with @credit_cards
      end

      ################################################################################################################

      api :GET, '/credit_cards/:id', 'Get a credit card in the system'
      description "Gets a credit card in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[credit_cards], :show, format }

      def show
        respond_with @credit_card
      end

      ################################################################################################################

      api :PUT, '/credit_cards/:id', 'Update a credit card in the system'
      description "Updates a credit card in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_credit_card, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[credit_cards], :update, format }

      def update
        @credit_card = update_credit_card @credit_card
        respond_with @credit_card
      end

      ################################################################################################################

      api :DELETE, '/credit_cards/:id', 'Delete a credit card in the system'
      description "Deletes a credit card in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[credit_cards], :destroy, format }

      def destroy
        @credit_card.destroy
        respond_with @credit_card
      end

      ################################################################################################################

      private

      def set_credit_card
        @credit_card = CreditCard.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'CreditCard'
      end

      def check_ownership
        render_model_not_found 'CreditCard' if not_admin_and?(!@user.owns(@credit_card))
      end

    end
  end
end