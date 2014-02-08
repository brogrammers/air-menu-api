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
      description 'Fetches all the companies in the system.'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/index.xml")
      def index
        @companies = Company.all
        respond_with @companies
      end

      api :GET, '/companies/:id', 'Get a company profile'
      description 'Fetches a company profile.'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.xml")
      def show
        @company = Company.find params[:id]
        respond_with @company
      end

      api :POST, '/companies', 'Create a new company'
      description 'Creates a new company.'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/users/show.xml")
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