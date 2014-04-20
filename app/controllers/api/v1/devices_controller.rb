module Api
  module V1
    class DevicesController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :user, :owner, :get_devices]
      doorkeeper_for :update, :scopes => [:admin, :user, :owner, :update_devices]
      doorkeeper_for :destroy, :scopes => [:admin, :user, :owner, :delete_devices]

      before_filter :set_device, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]
      before_filter :update_device, :only => [:update]

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

      api :GET, '/devices', 'All the devices in the system'
      description 'Fetches all the devices in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/devices/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/devices/index.xml")
      def index
        @devices = Device.all
        respond_with @devices
      end

      api :GET, '/devices/:id', 'Get a device in the system'
      description 'Gets a device in the system. ||admin user owner get_devices||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/devices/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/devices/show.xml")
      def show
        respond_with @device
      end

      api :PUT, '/devices/:id', 'Update a device in the system'
      description 'Updates a device in the system. ||admin user owner update_devices||'
      formats [:json, :xml]
      param :name, String, 'Device name'
      param :uuid, String, 'Device UUID'
      param :token, String, 'Device token'
      param :platform, [:ios], 'Device platform (currently only iOS)'
      example File.read("#{Rails.root}/public/docs/api/v1/devices/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/devices/update.xml")
      def update
        respond_with @device
      end

      api :DELETE, '/devices/:id', 'Delete a device in the system'
      description 'Deletes a device in the system. ||admin user owner delete_devices||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/devices/destroy.json")
      example File.read("#{Rails.root}/public/docs/api/v1/devices/destroy.xml")
      def destroy
        @device.destroy
        respond_with @device
      end

      private

      def set_device
        @device = Device.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Device'
      end

      def check_ownership
        render_model_not_found 'Device' if not_admin_and?(!@user.owns(@device))
      end

      def update_device
        @device.name = params[:name] || @device.name
        @device.uuid = params[:uuid] || @device.uuid
        @device.token = params[:token] || @device.token
        @device.platform = params[:platform] || @device.platform
        @device.save!
      end

    end
  end
end