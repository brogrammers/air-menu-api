module Api
  module V1
    module Me
      class DevicesController < BaseController
        SCOPES = {
            :index => [:user],
            :create => [:user]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

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

        ################################################################################################################

        api :GET, '/me/devices', 'All the devices of the currently logged-in user'
        description "Fetches all the devices of the currently logged-in user. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[me devices], :index, format }

        def index
          @devices = @user.devices
          respond_with @devices
        end

        ################################################################################################################

        api :POST, '/me/devices', 'Create a device for the currently logged-in user'
        description "Creates a device for the currently logged-in user. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_device, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[me devices], :create, format }

        def create
          @device = create_device @user
          respond_with @device, :status => :created
        end

        ################################################################################################################

      end
    end
  end
end