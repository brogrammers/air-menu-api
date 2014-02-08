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
      end

      api :GET, '/users', 'All the users in the system'
      description 'Fetches all the users in the system.'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/index.xml")
      def index
        @users = User.all
        respond_with @users
      end

      api :GET, '/users/:id', 'Get a users profile'
      description 'Fetches a user profile.'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.xml")
      def show
        @user = User.find params[:id]
        respond_with @user
      end

      api :POST, '/users', 'Create a new user'
      description 'Creates a new user.'
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

      private

      def create_user
        user = User.new
        user.name = params[:name]
        user.save!
        user
      end

      def create_identity
        identity = Identity.new
        identity.username = params[:username]
        identity.new_password = params[:password]
        identity.email = params[:email]
        identity.save!
        identity
      end

    end
  end
end