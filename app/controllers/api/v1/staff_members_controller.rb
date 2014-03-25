module Api
  module V1
    class StaffMembersController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :owner, :get_staff_members]

      before_filter :set_staff_member, :only => [:show]
      before_filter :check_ownership, :only => [:show]

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

      api :GET, '/staff_members', 'All the staff members in the system'
      description 'Fetches all the staff members in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/index.xml")
      def index
        @staff_members = StaffMember.all
        respond_with @staff_members
      end

      api :GET, '/staff_members/:id', 'Get a staff member in the system'
      description 'Gets a staff member in the system. ||admin owner get_staff_members||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/show.xml")
      def show
        respond_with @staff_member
      end

      private

      def set_staff_member
        @staff_member = StaffMember.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffMember'
      end

      def check_ownership
        render_model_not_found 'StaffMember' if not_admin_and?(!@user.owns(@staff_member.restaurant))
      end

    end
  end
end