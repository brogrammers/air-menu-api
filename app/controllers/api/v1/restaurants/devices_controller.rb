module Api
  module V1
    module Restaurants
      class DevicesController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_devices],
            :create => [:admin, :owner, :create_devices]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Restaurants > Devices'
          short_description 'All about devices of restaurants'
          path '/restaurants/:id/devices'
          description 'The Restaurant Devices endpoint lets you manage devices for a restaurants.' +
                          'Only a user with the right scope can create devices.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/devices', 'All the devices of a restaurant'
        description "Fetches all the devices of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants devices], :index, format }

        def index
          @devices = @restaurant.devices
          respond_with @devices
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/devices', 'Create a device for a restaurant'
        description "Creates a device for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_device, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants devices], :create, format }

        def create
          @device = create_device @restaurant
          respond_with @device, :status => :created
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