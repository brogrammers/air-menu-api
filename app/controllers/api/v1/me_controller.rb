module Api
  module V1
    class MeController < BaseController
      SCOPES = {
          :index => [:basic],
          :update => [:basic]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      resource_description do
        name 'Me'
        short_description 'Everything about the currently logged-in user'
        path '/me'
        description 'All around the currently logged-in user. Use this resource to interact with the currently logged-in users profile.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/me', 'Profile of the currently logged-in user'
      description "Fetches the profile of the currently logged-in user, based on the OAuth Access Token provided. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[me], :index, format }

      def index
        respond_with @user
      end

      ################################################################################################################

      api :PUT, '/me', 'Profile of the currently logged-in user'
      description "Fetches the profile of the currently logged-in user, based on the OAuth Access Token provided. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_user, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[me], :update, format }

      def update
        @user = update_user @user
        respond_with @user
      end

      ################################################################################################################

    end
  end
end