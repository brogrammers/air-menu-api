module Api
  module V1
    class CompaniesController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:user]
      doorkeeper_for :update, :scopes => [:owner]
      doorkeeper_for :create, :scopes => [:user]

      before_filter :set_company, :only => [:show, :update]
      before_filter :check_ownership, :only => [:update]
      before_filter :check_company_exists, :only => [:create]

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

      api :PUT, '/companies/:id', 'Update a company profile'
      description 'Updates a company profile. ||owner||'
      formats [:json, :xml]
      param :name, String, :desc => "Companies name"
      param :website, String, :desc => "Companies website"
      param :address_1, String, :desc => "Companies address line 1"
      param :address_2, String, :desc => "Companies address line 2"
      param :city, String, :desc => "Companies city"
      param :county, String, :desc => "Companies county"
      param :state, String, :desc => "Companies state (only US)"
      param :country, String, :desc => "Companies country"
      example File.read("#{Rails.root}/public/docs/api/v1/companies/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/companies/update.xml")
      def update
        @company.name = params[:name] || @company.name
        @company.website = params[:website] || @company.website
        @company.address.address_1 = params[:address_1] || @company.address.address_1
        @company.address.address_2 = params[:address_2] || @company.address.address_2
        @company.address.city = params[:city] || @company.address.city
        @company.address.county = params[:county] || @company.address.county
        @company.address.state = params[:state] || @company.address.state
        @company.address.country = params[:country] || @company.address.country
        @company.address.save!
        @company.save!
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
        respond_with @company, :status => :created
      end

      private

      def set_company
        @company = Company.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Company'
      end

      def check_ownership
        render_model_not_found 'Company' if not_admin_and?(!@user.owns(@company))
      end

      def check_company_exists
        render_conflict 'already_owns_company' if @user.company
      end

    end
  end
end