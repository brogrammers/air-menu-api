module Api
  module Oauth2
    class ApplicationsController < BaseController
      SCOPES = {
          :index => [:developer],
          :show => [:developer],
          :create => [:developer]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :get_applications, :only => [:index]

      resource_description do
        name 'OAuth Applications'
        short_description 'Everything you need to know about OAuth 2.0 applications'
        path '/oauth2'
        description 'An OAuth 2.0 application is needed to generate access tokens for users.'
      end

      ################################################################################################################

      api :GET, '/applications', 'Get all OAuth applications'
      description "Fetches all the OAuth applications. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[applications], :index, format }

      def index
        respond_with @applications
      end

      ################################################################################################################

      api :GET, '/applications/:id', 'Get a certain application'
      description "Fetches an OAuth application. This will specify the client id & secret. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[applications], :show, format }

      def show
        @application = Doorkeeper::Application.find params[:id]
        respond_with @application
      end

      ################################################################################################################

      api :POST, '/applications/:id', 'Create a new OAuth Application'
      description "Creates an OAuth 2.0 application. ||#{SCOPES[:create].join(' ')}||"
      formats FORMATS
      param_group :create_application, Api::Oauth2::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[applications], :create, format }

      def create
        @application = Doorkeeper::Application.new
        @application.name = params[:name]
        @application.redirect_uri = params[:redirect_uri]
        if scope_exists? 'admin'
          @application.trusted = params[:trusted] || false
        else
          @application.trusted = false
        end
        @user.applications << @application
        @application.save!
        respond_with @application
      end

      ################################################################################################################

      private

      def get_applications
        @applications = Set.new
        if scope_exists? 'admin'
          @applications.merge Doorkeeper::Application.where(:trusted => true)
        end
        @applications.merge @user.applications
      end
    end
  end
end