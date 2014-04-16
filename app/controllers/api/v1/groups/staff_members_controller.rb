module Api
  module V1
    module Groups
      class StaffMembersController < BaseController

        doorkeeper_for :index, :scopes => [:admin, :owner, :get_groups]
        doorkeeper_for :create, :scopes => [:admin, :owner, :create_groups]

        before_filter :set_group, :only => [:index, :create]
        before_filter :set_staff_member, :only => [:create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Groups > Staff Members'
          short_description 'All about the staff members in a group'
          path '/groups/:id/staff_kinds'
          description 'The Groups Staff Members endpoint lets you add staff members to a group.' +
                          'Only an owner can create staff_members.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        api :GET, '/groups/:id/staff_members', 'All the staff members in a group'
        description 'Fetches all the staff members in a group. ||admin owner get_groups||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/groups/staff_members/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/groups/staff_members/index.xml")
        def index
          @staff_members = @group.staff_members
          respond_with @staff_members
        end

        api :POST, '/groups/:id/staff_members', 'Add a new staff member to a group'
        description 'Adds a staff member to a group. ||admin owner create_groups||'
        formats [:json, :xml]
        param :staff_member_id, String, :desc => "Staff Member Id", :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/groups/staff_members/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/groups/staff_members/create.xml")
        def create
          @group.add_staff_member @staff_member
          @staff_member.save!
          respond_with @staff_member, :status => :created
        end

        private

        def set_group
          @group = Group.find params[:group_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Group'
        end

        def set_staff_member
          @staff_member = StaffMember.find params[:staff_member_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'StaffMember'
        end

        def check_ownership
          render_model_not_found 'Group' if not_admin_and?(!@user.owns(@group.restaurant))
        end

      end
    end
  end
end