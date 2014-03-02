module Api
  module V1
    class StaffKindsController < BaseController

      before_filter :set_staff_kind, :only => [:show]
      before_filter :check_ownership, :only => [:show]

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :owner, :get_staff_kinds]

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

      api :GET, '/staff_kinds', 'All the staff kinds in the system'
      description 'Fetches all the staff kinds in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/index.xml")
      def index
        @staff_kinds = StaffKind.all
        respond_with @staff_kinds
      end

      api :GET, '/staff_kinds/:id', 'Get a staff kind in the system'
      description 'Gets a staff kind in the system. ||admin owner get_staff_kinds||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/show.xml")
      def show
        respond_with @staff_kind
      end

      private

      def set_staff_kind
        @staff_kind = StaffKind.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffKind'
      end

      def check_ownership
        render_model_not_found 'StaffKind' if not_admin_and?(!@user.owns(@staff_kind.restaurant))
      end

    end
  end
end