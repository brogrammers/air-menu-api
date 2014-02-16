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

      api :POST, '/access_tokens', 'Create a new OAuth Access Token'
      description 'Creates an OAuth 2.0 access token. This action does not require an access token. <b>Scopes:</b> none'
      formats [:json, :xml]
      param :grant_type, ['password', 'refresh_token'], :desc => 'How to create an access token', :required => true
      param :username, String, :desc => 'The username', :required => true
      param :password, String, :desc => 'The password', :required => true
      param :refresh_token, String, :desc => 'The refresh token', :required => true
      param :client_id, String, :desc => 'The OAuth application client_id', :required => true
      param :client_secret, String, :desc => 'The OAuth application client_secret', :required => true
      param :scope, ['basic', 'user', 'admin', 'create_company'], :desc => 'The scope required', :required => true
      example File.read("#{Rails.root}/public/docs/api/oauth2/access_tokens/create.json")
      example File.read("#{Rails.root}/public/docs/api/oauth2/access_tokens/create.xml")
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