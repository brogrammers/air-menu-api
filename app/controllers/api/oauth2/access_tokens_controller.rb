module Api
  module Oauth2
    class AccessTokensController < BaseController
      class InvalidOAuthToken < StandardError; end
      include Doorkeeper::Helpers::Controller

      resource_description do
        name 'OAuth Access Tokens'
        short_description 'Everything you need to know about OAuth 2.0 access tokens'
        path '/oauth2'
        description 'All about OAuth 2.0 access tokens.'
      end

      ################################################################################################################

      api :POST, '/access_tokens', 'Create a new OAuth Access Token'
      description 'Creates an OAuth 2.0 access token. This action does not require an access token.'
      formats FORMATS
      param_group :create_access_token, Api::Oauth2::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[access_tokens], :create, format }

      def create
        response = strategy.authorize
        if response.class == Doorkeeper::OAuth::ErrorResponse
          render_oauth_error response.body
        else
          @access_token = response.token
          user.access_tokens << @access_token
          @access_token.save!
          respond_with @access_token
        end
      rescue Doorkeeper::Errors::DoorkeeperError => e
        handle_token_exception e
      end

      ################################################################################################################

      private

      def user
        @user ||= if params[:username] and params[:password]
          retrieve_by_credentials
        elsif params[:refresh_token]
          retrieve_by_refresh_token
        end
      end

      def retrieve_by_credentials
        identity = Identity.find_by_username(params[:username])
        identity if identity and identity.match_password(params[:password])
        identity.identifiable if identity
      end

      def retrieve_by_refresh_token
        access_token = Doorkeeper::AccessToken.find_by_refresh_token(params[:refresh_token])
        User.find access_token.owner_id if access_token
      end

      def strategy
        @strategy ||= server.token_request params[:grant_type]
      end

    end
  end
end