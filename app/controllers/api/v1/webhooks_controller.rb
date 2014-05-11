module Api
  module V1
    class WebhooksController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :owner, :get_webhooks],
          :update => [:admin, :owner, :update_webhooks],
          :destroy => [:admin, :owner, :delete_webhooks]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_webhook, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]

      resource_description do
        name 'Webhooks'
        short_description 'All about the webhooks in the system'
        path '/webhooks'
        description 'The Webhook endpoint is used for managing and creating new webhooks inside the system' +
                        'Only users with the right scopes can alter webhooks.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/webhooks', 'All the webhooks in the system'
      description "Fetches all the webhooks in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[webhooks], :index, format }

      def index
        @webhooks = Webhook.all
        respond_with @webhooks
      end

      ################################################################################################################

      api :GET, '/webhooks/:id', 'Get a webhook profile'
      description "Fetches a webhook profile. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[webhooks], :show, format }

      def show
        respond_with @user
      end

      ################################################################################################################

      api :PUT, '/webhooks/:id', 'Update a webhook profile'
      description "Updates a webhook profile. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_webhook, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[webhooks], :update, format }

      def update
        update_webhook @webhook
        respond_with @webhook
      end

      ################################################################################################################

      api :DELETE, '/webhooks/:id', 'Delete a webhook profile'
      description "Deletes a webhook profile. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[webhooks], :destroy, format }

      def destroy
        @webhook.destroy
        respond_with @webhook
      end

      ################################################################################################################

      private

      def set_webhook
        @webhook = Webhook.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Webhook'
      end

      def check_ownership
        render_model_not_found 'Webhook' if not_admin_and?(!@user.owns(@webhook.restaurant))
      end

    end
  end
end