module Api
  module V1
    class StaffMembersController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :owner, :get_staff_members],
          :update => [:admin, :owner, :update_staff_members],
          :destroy => [:admin, :owner, :delete_staff_members]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_staff_member, :only => [:show, :update, :destroy]
      before_filter :set_staff_kind, :only => [:update]
      before_filter :check_ownership, :only => [:show, :update, :destroy]

      resource_description do
        name 'Staff Members'
        short_description 'All about staff members in the system'
        path '/staff_kinds'
        description 'The Staff Members endpoint lets you inspect staff members in the system.' +
                        'Only a users with the right scope can inspect staff members.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/staff_members', 'All the staff members in the system'
      description "Fetches all the staff members in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[staff_members], :index, format }

      def index
        @staff_members = StaffMember.all
        respond_with @staff_members
      end

      ################################################################################################################

      api :GET, '/staff_members/:id', 'Get a staff member in the system'
      description "Gets a staff member in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[staff_members], :show, format }

      def show
        respond_with @staff_member
      end

      ################################################################################################################

      api :PUT, '/staff_members/:id', 'Update a staff member in the system'
      description "Updates a staff member in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_staff_member, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[staff_members], :update, format }

      def update
        @staff_member = update_staff_member @staff_member, @staff_kind
        respond_with @staff_member
      end

      ################################################################################################################

      api :DELETE, '/staff_members/:id', 'Delete a staff member in the system'
      description "Deletes a staff member in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[staff_members], :destroy, format }

      def destroy
        @staff_member.destroy
        respond_with @staff_member
      end

      ################################################################################################################

      private

      def set_staff_member
        @staff_member = StaffMember.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffMember'
      end

      def set_staff_kind
        @staff_kind = StaffKind.find params[:staff_kind_id] if params[:staff_kind_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffKind'
      end

      def check_ownership
        render_model_not_found 'StaffMember' if not_admin_and?(!@user.owns(@staff_member.restaurant))
      end

    end
  end
end