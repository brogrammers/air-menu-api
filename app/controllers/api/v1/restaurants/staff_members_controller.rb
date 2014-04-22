module Api
  module V1
    module Restaurants
      class StaffMembersController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_staff_members],
            :create => [:admin, :owner, :create_staff_members]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :set_staff_kind, :only => [:create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Restaurants > Staff Members'
          short_description 'All about staff members of restaurants'
          path '/restaurants/:id/staff_members'
          description 'The Restaurant Staff Members endpoint lets you create new staff members for a restaurants.' +
                          'Only a users with the right scope can create staff members.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/staff_members', 'All the staff members of a restaurant'
        description "Fetches all the staff members of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants staff_members], :index, format }

        def index
          @staff_members = @restaurant.staff_members
          respond_with @staff_members
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/staff_members', 'Create a staff member for a restaurant'
        description "Creates a staff member for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_staff_member, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants staff_members], :create, format }

        def create
          @staff_member = create_staff_member @restaurant, @staff_kind
          respond_with @staff_member, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def set_staff_kind
          @staff_kind = StaffKind.find params[:staff_kind_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'StaffKind'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end