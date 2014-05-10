module Api
  module V1
    class DevicesController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :user, :owner, :get_devices],
          :update => [:admin, :user, :owner, :update_devices],
          :destroy => [:admin, :user, :owner, :delete_devices]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_device, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]

      resource_description do
        name 'Devices'
        short_description 'All about devices in the system'
        path '/devices'
        description 'The Devices endpoint lets you manage devices in the system.' +
                        'Only a users with the right scope can manage devices.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/devices', 'All the devices in the system'
      description "Fetches all the devices in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[devices], :index, format }

      def index
        @devices = Device.all
        respond_with @devices
      end

      ################################################################################################################

      api :GET, '/devices/:id', 'Get a device in the system'
      description "Gets a device in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[devices], :show, format }

      def show
        respond_with @device
      end

      ################################################################################################################

      api :PUT, '/devices/:id', 'Update a device in the system'
      description "Updates a device in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_device, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[devices], :update, format }

      def update
        @device = update_device @device
        respond_with @device
      end

      ################################################################################################################

      api :DELETE, '/devices/:id', 'Delete a device in the system'
      description "Deletes a device in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[devices], :destroy, format }

      def destroy
        @device.destroy
        respond_with @device
      end

      ################################################################################################################

      private

      def set_device
        @device = Device.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Device'
      end

      def check_ownership
        render_model_not_found 'Device' if not_admin_and?(!@user.owns(@device))
      end

    end
  end
end