module Api
  module V1
    module Restaurants
      class OpeningHoursController < BaseController
        SCOPES = {
            :index => [:admin, :user, :owner, :get_opening_hours],
            :create => [:admin, :owner, :create_opening_hours]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:create]

        resource_description do
          name 'Restaurants > Opening Hours'
          short_description 'All about opening hours of restaurants'
          path '/restaurants/:id/opening_hours'
          description 'The Restaurant Opening Hours endpoint lets you manage opening hours of a restaurants.' +
                          'Only users with the right scope can create opening hours.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/opening_hours', 'All the opening hours of a restaurant'
        description "Fetches all the opening hours of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants opening_hours], :index, format }

        def index
          @opening_hours = @restaurant.opening_hours
          respond_with @opening_hours
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/opening_hours', 'Create an opening hour for a restaurant'
        description "Creates an opening hour for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_opening_hour, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants opening_hours], :create, format }

        def create
          @opening_hour = create_opening_hour @restaurant
          respond_with @opening_hour, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end