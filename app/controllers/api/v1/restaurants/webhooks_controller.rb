module Api
  module V1
    module Restaurants
      class WebhooksController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_webhooks],
            :create => [:admin, :owner, :create_webhooks]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Restaurants > Webhooks'
          short_description 'All about webhooks of restaurants'
          path '/restaurants/:id/webhooks'
          description 'The Restaurant Webhooks endpoint lets you create new webhooks for a restaurants.' +
                          'Only a users with the right scope can create webhooks.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/webhooks', 'All the webhooks of a restaurant'
        description "Fetches all the webhooks of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants webhooks], :index, format }

        def index
          @webhooks = @restaurant.webhooks
          respond_with @webhooks
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/webhooks', 'Create a webhook for a restaurant'
        description "Creates a webhook for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_webhook, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants webhooks], :create, format }

        def create
          @webhook = create_webhook @restaurant
          respond_with @webhook, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end