module Api
  module V1
    class CompaniesController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:user]
      doorkeeper_for :create, :scopes => [:user, :create_company]

      resource_description do
        name 'Companies'
        short_description 'All about the companies in the system'
        path '/companies'
        description 'The Company endpoint lets you create new companies associated with the currently logged in user.' +
                        'A company can only be created iff the logged in entity is a user.'
      end

      api :GET, '/companies', 'All the companies in the system'
      description 'Fetches all the companies in the system. <b>Scopes:</b> admin'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/companies/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/companies/index.xml")
      def index
        @companies = Company.all
        respond_with @companies
      end

      api :GET, '/companies/:id', 'Get a company profile'
      description 'Fetches a company profile. <b>Scopes:</b> user'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/companies/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/companies/show.xml")
      def show
        @company = Company.find params[:id]
        respond_with @company
      end

      api :POST, '/companies', 'Create a new company'
      description 'Creates a new company. <b>Scopes:</b> user create_company'
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

      def create_company
        company = Company.new
        company.name = params[:name]
        company.website = params[:website]
        company.save!
        company
      end

      def create_address
        address = Address.new
        address.address_1 = params[:address_1]
        address.address_2 = params[:address_2]
        address.city = params[:city]
        address.county = params[:county]
        address.state = params[:state]
        address.country = params[:country]
        address.save!
        address
      end

    end
  end
end