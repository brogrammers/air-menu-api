module Api
  module V1
    class RestaurantsController < BaseController

      doorkeeper_for :index, :scopes => [:admin, :user]
      doorkeeper_for :show, :scopes => [:admin, :user]

      before_filter :set_restaurant, :only => [:show]

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

      private

      def set_restaurant
        @restaurant = Restaurant.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Restaurant'
      end

    end
  end
end