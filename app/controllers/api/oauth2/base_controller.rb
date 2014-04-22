module Api
  module Oauth2
    class BaseController < ApplicationController
      include Api::V1::BaseHelper

      resource_description do
        api_version 'oauth2'
        app_info File.read("#{Rails.root}/doc/oauth2.txt")
        api_base_url '/api/oauth2'
      end

      def self.example_file(resources, action, format)
        File.read("#{Rails.root}/public/docs/api/oauth2/#{resources.join('/')}/#{action}.#{format}") rescue ''
      end

      def_param_group :create_access_token do
        param :grant_type, %w[password refresh_token], :desc => 'How to create an access token', :required => true
        param :username, String, :desc => 'The username'
        param :password, String, :desc => 'The password'
        param :refresh_token, String, :desc => 'The refresh token'
        param :client_id, String, :desc => 'The OAuth application client_id', :required => true
        param :client_secret, String, :desc => 'The OAuth application client_secret', :required => true
        param :scope, String, :desc => 'The scope required', :required => true
      end

      def_param_group :create_application do
        param :name, String, :desc => 'Application name', :required => true
        param :redirect_uri, String, :desc => 'A redirection url', :required => true
        param :trusted, :bool, :desc => 'Trusted Application. ||admin||'
      end

    end
  end
end