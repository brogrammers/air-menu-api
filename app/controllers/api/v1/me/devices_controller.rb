module Api
  module V1
    module Me
      class DevicesController < BaseController

        doorkeeper_for :index, :scopes => [:user]
        doorkeeper_for :create, :scopes => [:user]

        resource_description do
          name 'Me > Devices'
          short_description 'All about the devices of the currently logged-in user'
          path '/me/devices'
          description 'The Restaurant Devices endpoint lets you manage devices for a restaurants.' +
                          'Only a users with the right scope can create groups.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        api :GET, '/me/devices', 'All the devices of the currently logged-in user'
        description 'Fetches all the devices of the currently logged-in user. ||user||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/me/devices/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/me/devices/index.xml")
        def index
          @devices = @user.devices
          respond_with @devices
        end

        api :POST, '/me/devices', 'Create a device for the currently logged-in user'
        description 'Creates a device for the currently logged-in user. ||user||'
        formats [:json, :xml]
        param :name, String, 'Device name', :required => true
        param :uuid, String, 'Device UUID', :required => true
        param :token, String, 'Device token', :required => true
        param :platform, :device_platform, 'Device platform (currently only iOS)', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/me/devices/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/me/devices/create.xml")
        def create
          @device = create_device @user
          respond_with @device, :status => :created
        end

      end
    end
  end
end