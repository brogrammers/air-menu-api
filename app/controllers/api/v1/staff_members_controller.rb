module Api
  module V1
    class StaffMembersController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :owner, :get_staff_members]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_staff_members]
      doorkeeper_for :destroy, :scopes => [:admin, :owner, :delete_staff_members]

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
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/show.xml")
      def show
        respond_with @staff_member
      end

      api :PUT, '/staff_members/:id', 'Update a staff member in the system'
      description 'Updates a staff member in the system. ||admin owner update_staff_members||'
      formats [:json, :xml]
      param :name, String, 'New Staff Member name'
      param :password, String, 'New Staff Member password'
      param :email, String, 'New Staff Member email'
      param :staff_kind_id, String, 'Set Staff Members staff kind id'
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/update.xml")
      def update
        @staff_member.name = params[:name] || @staff_member.name
        @staff_member.identity.new_password = params[:password] if params[:password]
        @staff_member.identity.email = params[:email] || @staff_member.identity.email
        @staff_member.staff_kind = @staff_kind if @staff_kind
        @staff_member.identity.save!
        @staff_member.save!
        respond_with @staff_member
      end

      api :DELETE, '/staff_members/:id', 'Delete a staff member in the system'
      description 'Deletes a staff member in the system. ||admin owner delete_staff_members||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_members/update.xml")
      def destroy
        respond_with @staff_member
      end

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