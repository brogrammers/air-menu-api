module Api
  module V1
    module Restaurants
      class DevicesController < BaseController

        doorkeeper_for :index, :scopes => [:admin, :owner, :get_devices]
        doorkeeper_for :create, :scopes => [:admin, :owner, :create_devices]

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Restaurants > Devices'
          short_description 'All about devices of restaurants'
          path '/restaurants/:id/devices'
          description 'The Restaurant Devices endpoint lets you manage devices for a restaurants.' +
                          'Only a users with the right scope can create groups.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        api :GET, '/restaurants/:id/devices', 'All the devices of a restaurant'
        description 'Fetches all the devices of a restaurant. ||admin owner get_devices||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/devices/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/devices/index.xml")
        def index
          @devices = @restaurant.devices
          respond_with @devices
        end

        api :POST, '/restaurants/:id/devices', 'Create a device for a restaurant'
        description 'Creates a device for a restaurant. ||admin owner create_devices||'
        formats [:json, :xml]
        param :name, String, 'Device name', :required => true
        param :uuid, String, 'Device UUID', :required => true
        param :token, String, 'Device token'
        param :platform, [:ios], 'Device platform (currently only iOS)', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/devices/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/devices/create.xml")
        def create
          @device = create_device @restaurant
          respond_with @device, :status => :created
        end

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