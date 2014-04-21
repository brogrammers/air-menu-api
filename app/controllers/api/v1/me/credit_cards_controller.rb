module Api
  module V1
    module Me
      class CreditCardsController < BaseController

        doorkeeper_for :index, :scopes => [:user, :owner]
        doorkeeper_for :create, :scopes => [:user, :owner]

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

        api :GET, '/me/credit_cards', 'All the credit cards of the currently logged-in user'
        description 'Fetches a credit card of the currently logged-in user. ||user owner||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/me/credit_cards/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/me/credit_cards/index.xml")
        def index
          @credit_cards = @user.credit_cards
          respond_with @credit_cards
        end

        api :POST, '/me/credit_cards', 'Create a credit card for the currently logged-in user'
        description 'Creates a credit card for the currently logged-in user. ||user owner||'
        formats [:json, :xml]
        param :number, String, :desc => 'Credit Card number (16 digits)', :required => true
        param :card_type, ['VISA', 'MASTERCARD'], :desc => 'Credit Card type', :required => true
        param :month, String, :desc => 'Credit Card expiry month', :required => true
        param :year, String, :desc => 'Credit Card expiry year', :required => true
        param :cvc, String, :desc => 'Credit Card CVC', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/me/credit_cards/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/me/credit_cards/index.xml")
        def create
          @credit_card = create_credit_card @user
          respond_with @credit_card, :status => :created
        end

      end
    end
  end
end