module Api
  module V1
    module Me
      class CreditCardsController < BaseController
        SCOPES = {
            :index => [:user, :owner],
            :create => [:user, :owner]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        resource_description do
          name 'Me > Credit Cards'
          short_description 'All about the credit cards of the currently logged-in user'
          path '/me/credit_cards'
          description 'The Restaurant Credit Cards endpoint lets you manage credit cards for a currently logged in user.' +
                          'Only a users with the right scope can manage credit cards.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/me/credit_cards', 'All the credit cards of the currently logged-in user'
        description "Fetches a credit card of the currently logged-in user. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[me credit_cards], :index, format }

        def index
          @credit_cards = @user.credit_cards
          respond_with @credit_cards
        end

        ################################################################################################################

        api :POST, '/me/credit_cards', 'Create a credit card for the currently logged-in user'
        description "Creates a credit card for the currently logged-in user. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_credit_card, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[me credit_cards], :index, format }

        def create
          @credit_card = create_credit_card @user
          respond_with @credit_card, :status => :created
        end

        ################################################################################################################

      end
    end
  end
end