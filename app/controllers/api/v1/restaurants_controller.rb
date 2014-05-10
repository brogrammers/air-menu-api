module Api
  module V1
    class RestaurantsController < BaseController
      SCOPES = {
          :index => [:admin, :user],
          :show => [:admin, :user],
          :update => [:admin, :user, :owner],
          :destroy => [:admin, :user, :owner],
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

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

      ################################################################################################################

      api :GET, '/restaurants', 'All the restaurants in the system'
      description "Fetches all the restaurants in the system by location. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      param_group :search_restaurant, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[restaurants], :index, format }

      def index
        @locations = Location.all_within(params[:latitude].to_f || 0, params[:longitude].to_f || 0, params[:offset].to_f || 0)
        @restaurants = []
        @locations.each do |location|
          @restaurants <<(location.findable) if location.findable.class == Restaurant
        end
        respond_with @restaurants
      end

      ################################################################################################################

      api :GET, '/restaurants/:id', 'Get a Restaurant profile'
      description "Fetches a restaurant profile. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[restaurants], :show, format }

      def show
        respond_with @restaurant
      end

      ################################################################################################################

      api :PUT, '/restaurants/:id', 'Change a Restaurant profile'
      description "Changes a restaurant profile. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_restaurant, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[restaurants], :update, format }

      def update
        @restaurant = update_restaurant @restaurant
        respond_with @restaurant
      end

      ################################################################################################################

      api :DELETE, '/restaurants/:id', 'Delete a Restaurant profile'
      description "Deletes a restaurant profile. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[restaurants], :index, format }

      def destroy
        @restaurant.destroy
        respond_with @restaurant
      end

      ################################################################################################################

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