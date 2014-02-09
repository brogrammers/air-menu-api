module Api
  module V1
    class RestaurantsController < BaseController

      doorkeeper_for :index, :scopes => [:user]
      doorkeeper_for :show, :scopes => [:user]
      doorkeeper_for :create, :scopes => [:owner]

      resource_description do
        name 'Restaurants'
        short_description 'All about the restaurants in the system'
        path '/restaurants'
        description 'The Restaurant endpoint lets you create new restaurants for a company.' +
                        'Only an owner can create restaurants.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/restaurants', 'All the restaurants in the system'
      description 'Fetches all the restaurants in the system. <b>Scopes:</b> user'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.xml")
      def index
        @restaurants = Restaurant.all
        respond_with @restaurants
      end

      api :GET, '/restaurants/:id', 'Get a Restaurant profile'
      description 'Fetches a restaurant profile. <b>Scopes:</b> user'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/show.xml")
      def show
        @restaurant = Restaurant.find params[:id]
        respond_with @restaurant
      end

      api :POST, '/restaurants', 'Create a new restaurant'
      description 'Creates a new company. Only owners can create new restaurants. <b>Scopes:</b> owner'
      formats [:json, :xml]
      param :name, String, :desc => "Restaurant Name", :required => true
      param :company_id, String, :desc => "Companies id", :required => true
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
        respond_with @restaurant
      end

    end
  end
end