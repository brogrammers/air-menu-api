module Api
  module V1
    class CompanyRestaurantsController < BaseController

      before_filter :set_company, :only => [:index, :create]
      before_filter :check_ownership, :only => [:create]

      doorkeeper_for :index, :scopes => [:user]
      doorkeeper_for :create, :scopes => [:owner]

      resource_description do
        name 'Companies > Restaurants'
        short_description 'All about the restaurants in of companies'
        path '/companies/:id/restaurants'
        description 'The Company Restaurants endpoint lets you create new restaurants for a company.' +
                        'Only an owner can create restaurants.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/companies/:id/restaurants', 'All the restaurants of a company'
      description 'Fetches all the restaurants in the system. ||user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.xml")
      def index
        @restaurants = @company.restaurants
        respond_with @restaurants
      end

      api :POST, '/companies/:id/restaurants', 'Create a new restaurant'
      description 'Creates a new company. Only owners can create new restaurants. ||owner||'
      formats [:json, :xml]
      param :name, String, :desc => "Restaurant Name", :required => true
      param :address_1, String, :desc => "Restaurants address line 1", :required => true
      param :address_2, String, :desc => "Restaurants address line 2", :required => true
      param :city, String, :desc => "Restaurants city", :required => true
      param :county, String, :desc => "Restaurants county", :required => true
      param :state, String, :desc => "Restaurants state (only US)"
      param :country, String, :desc => "Restaurants country", :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/show.xml")
      def create
        @restaurant = create_restaurant
        @address = create_address
        @restaurant.address = @address
        @address.save!
        @company.restaurants << @restaurant
        @restaurant.save!
        respond_with @restaurant
      end

      private

      def set_company
        @company = Company.find params[:company_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Company'
      end

      def check_ownership
        render_forbidden 'ownership_failure' if !@user.owns @company and !scope_exists? 'admin'
      end

    end
  end
end