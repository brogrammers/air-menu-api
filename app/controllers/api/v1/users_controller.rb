module Api
  module V1
    class UsersController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:basic, :user]

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

      api :GET, '/users', 'All the users in the system'
      description 'Fetches all the users in the system. <b>Scopes:</b> admin'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/index.xml")
      def index
        @users = User.all
        respond_with @users
      end

      api :GET, '/users/:id', 'Get a users profile'
      description 'Fetches a user profile. <b>Scopes:</b> basic user'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.xml")
      def show
        @user = User.find params[:id]
        respond_with @user
      end

      api :POST, '/users', 'Create a new user'
      description 'Creates a new user. No scopes or Access Token needed to perform this action <b>Scopes:</b> none'
      formats [:json, :xml]
      param :name, String, :desc => "Users full name", :required => true
      param :username, String, :desc => "Desired username", :required => true
      param :password, String, :desc => "Desired password", :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.xml")
      def create
        @user = create_user
        @identity = create_identity
        @user.identity = @identity
        @identity.save!
        respond_with @user
      end

    end
  end
end