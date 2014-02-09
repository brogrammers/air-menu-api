module Api
  module Oauth2
    class ApplicationsController < BaseController

      doorkeeper_for :index, :show, :create, :scopes => [:developer]

      resource_description do
        name 'OAuth Applications'
        short_description 'Everything you need to know about OAuth 2.0 applications'
        path '/oauth2'
        description 'An OAuth 2.0 application is needed to generate access tokens for users.'
      end

      api :GET, '/applications', 'Get all OAuth applications'
      description 'Fetches all the OAuth applications. <b>Scopes:</b> developer'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/oauth2/applications/index.json")
      example File.read("#{Rails.root}/public/docs/api/oauth2/applications/index.xml")
      def index
        @applications = Doorkeeper::Application.all
        respond_with @applications
      end

      api :GET, '/applications/:id', 'Get a certain application'
      description 'Fetches an OAuth application. This will specify the client id & secret. <b>Scopes:</b> developer'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/oauth2/applications/show.json")
      example File.read("#{Rails.root}/public/docs/api/oauth2/applications/show.xml")
      def show
        @application = Doorkeeper::Application.find params[:id]
        respond_with @application
      end

      api :POST, '/applications/:id', 'Create a new OAuth Application'
      description 'Creates an OAuth 2.0 application. <b>Scopes:</b> developer'
      formats [:json, :xml]
      param :name, String, :desc => 'Application name', :required => true
      param :redirect_uri, String, :desc => 'A redirection url', :required => true
      example File.read("#{Rails.root}/public/docs/api/oauth2/applications/show.json")
      example File.read("#{Rails.root}/public/docs/api/oauth2/applications/show.xml")
      def create
        @application = Doorkeeper::Application.new
        @application.name = params[:name]
        @application.redirect_uri = params[:redirect_uri]
        @application.save!
        respond_with @application
      end
    end
  end
end