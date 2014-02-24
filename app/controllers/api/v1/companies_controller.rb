module Api
  module V1
    class CompaniesController < BaseController

      before_filter :set_company, :only => [:show]
      before_filter :check_company_exists, :only => [:create]

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:user]
      doorkeeper_for :create, :scopes => [:user]

      resource_description do
        name 'Companies'
        short_description 'All about the companies in the system'
        path '/companies'
        description 'The Company endpoint lets you create new companies associated with the currently logged in user.' +
                        'A company can only be created iff the logged in entity is a user.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 409, 'Conflict, some action can\'t be performed due to a conflict'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/companies', 'All the companies in the system'
      description 'Fetches all the companies in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/companies/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/companies/index.xml")
      def index
        @companies = Company.all
        respond_with @companies
      end

      api :GET, '/companies/:id', 'Get a company profile'
      description 'Fetches a company profile. ||user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/companies/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/companies/show.xml")
      def show
        respond_with @company
      end

      api :POST, '/companies', 'Create a new company'
      description 'Creates a new company. ||user||'
      formats [:json, :xml]
      param :name, String, :desc => "Companies name", :required => true
      param :website, String, :desc => "Companies website", :required => true
      param :address_1, String, :desc => "Companies address line 1", :required => true
      param :address_2, String, :desc => "Companies address line 2", :required => true
      param :city, String, :desc => "Companies city", :required => true
      param :county, String, :desc => "Companies county", :required => true
      param :state, String, :desc => "Companies state (only US)"
      param :country, String, :desc => "Companies country", :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/companies/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/companies/show.xml")
      def create
        @company = create_company
        @user.company = @company
        @company.save!
        @company.address = create_address
        @company.address.save!
        respond_with @user
      end

      private

      def set_company
        @company = Company.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Company'
      end

      def check_company_exists
        render_conflict 'already_owns_company' if @user.company
      end

    end
  end
end