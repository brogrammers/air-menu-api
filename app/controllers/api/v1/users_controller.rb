module Api
  module V1
    class UsersController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :basic, :user]
          #TODO: change back to trusted scope
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_user, :only => [:show]

      resource_description do
        name 'Users'
        short_description 'All about the users in the system'
        path '/users'
        description 'The User endpoint is used for managing and creating new users inside the system' +
                    'A user is identifiable, which means it can be associated with some sort of credentials.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/users', 'All the users in the system'
      description "Fetches all the users in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[users], :index, format }

      def index
        @users = User.all
        respond_with @users
      end

      ################################################################################################################

      api :GET, '/users/:id', 'Get a users profile'
      description "Fetches a user profile. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[users], :show, format }

      def show
        respond_with @user
      end

      ################################################################################################################

      api :POST, '/users', 'Create a new user'
      description "Creates a new user. No scopes or Access Token needed to perform this action. ||||"
      formats FORMATS
      param_group :create_user, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[users], :create, format }

      def create
        @user = create_user
        respond_with @user, :status => :created
      end

      ################################################################################################################

      private

      def set_user
        @user = User.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'User'
      end

    end
  end
end