module Api
  module V1
    class RestaurantsController < BaseController

      doorkeeper_for :index, :scopes => [:admin, :user]
      doorkeeper_for :show, :scopes => [:admin, :user]
      doorkeeper_for :update, :scopes => [:admin, :owner]
      doorkeeper_for :destroy, :scopes => [:admin, :owner]

      before_filter :set_restaurant, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:update, :destroy]

      resource_description do
        name 'Restaurants'
        short_description 'All about the restaurants in the system'
        path '/restaurants'
        description 'The Restaurant endpoint lets you administrate restaurants in the system.' +
                        'Only an owner can create restaurants.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/restaurants', 'All the restaurants in the system'
      description 'Fetches all the restaurants in the system by location. ||admin user||'
      formats [:json, :xml]
      param :latitude, String, :desc => "Latitude", :required => true
      param :longitude, String, :desc => "Longitude", :required => true
      param :offset, String, :desc => "Offset", :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/index.xml")
      def index
        @locations = Location.all_within(params[:latitude].to_f||0, params[:longitude].to_f||0, params[:offset].to_f||0)
        @restaurants = []
        @locations.each do |location|
          @restaurants <<(location.findable) if location.findable.class == Restaurant
        end
        respond_with @restaurants
      end

      api :GET, '/restaurants/:id', 'Get a Restaurant profile'
      description 'Fetches a restaurant profile. ||admin user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/show.xml")
      def show
        respond_with @restaurant
      end

      api :PUT, '/restaurants/:id', 'Change a Restaurant profile'
      description 'Changes a restaurant profile. ||admin owner||'
      formats [:json, :xml]
      param :name, String, :desc => "New Restaurant Name"
      param :address_1, String, :desc => "New Restaurant address line 1"
      param :address_2, String, :desc => "New Restaurant address line 2"
      param :city, String, :desc => "New Restaurant city"
      param :county, String, :desc => "New Restaurants county"
      param :state, String, :desc => "New Restaurants state (only US)"
      param :country, String, :desc => "New Restaurants country"
      param :latitude, :latitude, :desc => "New Restaurants latitude"
      param :longitude, :longitude, :desc => "New Restaurants longitude"
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/update.xml")
      def update
        @restaurant.name = params[:name] || @restaurant.name
        @restaurant.address.address_1 = params[:address_1] || @restaurant.address.address_1
        @restaurant.address.address_2 = params[:address_2] || @restaurant.address.address_2
        @restaurant.address.city = params[:city] || @restaurant.address.city
        @restaurant.address.county = params[:county] || @restaurant.address.county
        @restaurant.address.state = params[:state] || @restaurant.address.state
        @restaurant.address.country = params[:country] || @restaurant.address.country
        @restaurant.location.latitude = params[:latitude] || @restaurant.location.latitude if @restaurant.location
        @restaurant.location.longitude = param[:longitude] || @restaurant.location.longitude if @restaurant.location
        @restaurant.address.save!
        @restaurant.location.save! if @restaurant.location
        @restaurant.save!
        respond_with @restaurant
      end

      api :DELETE, '/restaurants/:id', 'Delete a Restaurant profile'
      description 'Deletes a restaurant profile. ||admin owner||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/destroy.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurants/destroy.xml")
      def destroy
        @restaurant.destroy
        respond_with @restaurant
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Restaurant'
      end

      def check_ownership
        render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
      end

    end
  end
end