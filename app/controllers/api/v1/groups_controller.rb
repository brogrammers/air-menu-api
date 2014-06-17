module Api
  module V1
    class GroupsController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :owner, :get_groups],
          :update => [:admin, :owner, :update_groups],
          :destroy => [:admin, :owner, :delete_groups]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_group, :only => [:show, :update, :destroy]
      before_filter :set_device, :only => [:update]
      before_filter :set_staff_members, :only => [:update]
      before_filter :check_ownership, :only => [:show, :update, :destroy]

      resource_description do
        name 'Groups'
        short_description 'All about groups in the system'
        path '/groups'
        description 'The Groups endpoint lets you inspect groups in the system.' +
                        'Only a users with the right scope can inspect groups.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/groups', 'All the groups in the system'
      description "Fetches all the groups in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[groups], :index, format }

      def index
        @groups = Group.all
        respond_with @groups
      end

      ################################################################################################################

      api :GET, '/groups/:id', 'Get a group in the system'
      description "Gets a group in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[groups], :show, format }

      def show
        respond_with @group
      end

      ################################################################################################################

      api :PUT, '/groups/:id', 'Update a group in the system'
      description "Updates a group in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_group, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[groups], :update, format }

      def update
        @group = update_group @group, @device, @staff_members
        @group = Group.find params[:id]
        respond_with @group
      end

      ################################################################################################################

      api :DELETE, '/groups/:id', 'Delete a group in the system'
      description "Deletes a group in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[groups], :destroy, format }

      def destroy
        @group.destroy
        respond_with @group
      end

      ################################################################################################################

      private

      def set_group
        @group = Group.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Group'
      end

      def set_device
        @device = Device.find params[:device_id] if params[:device_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Device'
      end

      def set_staff_members
        @staff_members = []
        params[:staff_members].split(' ').each do |staff_member_id|
          staff_member = StaffMember.find_by_id(staff_member_id)
          render_bad_request ['staff_members'] unless staff_member
          @staff_members << staff_member
        end if params[:staff_members]
      end

      def check_ownership
        render_model_not_found 'Group' if not_admin_and?(!@user.owns(@group.restaurant))
        render_forbidden 'ownership_failure' if @device && @device.notifiable_type == 'Restaurant' && @device.notifiable_id != @group.restaurant.id
      end

    end
  end
end