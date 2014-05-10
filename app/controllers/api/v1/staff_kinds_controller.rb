module Api
  module V1
    class StaffKindsController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :owner, :get_staff_kinds],
          :update => [:admin, :owner, :update_staff_kinds],
          :destroy => [:admin, :owner, :delete_staff_kinds]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_staff_kind, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]
      before_filter :set_scopes, :only => [:update]

      resource_description do
        name 'Staff Kinds'
        short_description 'All about staff kinds in the system'
        path '/staff_kinds'
        description 'The  Staff Kinds endpoint lets you inspect staff kinds in the system.' +
                        'Only a users with the right scope can inspect staff kinds.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/staff_kinds', 'All the staff kinds in the system'
      description "Fetches all the staff kinds in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[staff_kinds], :index, format }

      def index
        @staff_kinds = StaffKind.all
        respond_with @staff_kinds
      end

      ################################################################################################################

      api :GET, '/staff_kinds/:id', 'Get a staff kind in the system'
      description "Gets a staff kind in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[staff_kinds], :show, format }

      def show
        respond_with @staff_kind
      end

      ################################################################################################################

      api :PUT, '/staff_kinds/:id', 'Change a staff kind in the system'
      description "Changes a staff kind in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_staff_kind, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[staff_kinds], :update, format }

      def update
        @staff_kind = update_staff_kind @staff_kind, @staff_kind_scopes
        respond_with @staff_kind
      end

      ################################################################################################################

      api :DELETE, '/staff_kinds/:id', 'Delete a staff kind in the system'
      description "Deletes a staff kind in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[staff_kinds], :update, format }

      def destroy
        @staff_kind.destroy
        respond_with @staff_kind
      end

      ################################################################################################################

      private

      def set_staff_kind
        @staff_kind = StaffKind.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffKind'
      end

      def set_scopes
        @staff_kind_scopes = []
        params[:scopes].split(' ').each do |scope_name|
          scope = Scope.find_by_name(scope_name)
          render_bad_request ['scopes'] unless scope
          @staff_kind_scopes << scope
        end if params[:scopes]
      end

      def check_ownership
        render_model_not_found 'StaffKind' if not_admin_and?(!@user.owns(@staff_kind.restaurant))
      end

    end
  end
end