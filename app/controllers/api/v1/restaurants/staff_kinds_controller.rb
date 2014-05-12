module Api
  module V1
    module Restaurants
      class StaffKindsController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_staff_kinds],
            :create => [:admin, :owner, :create_staff_kinds]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]
        before_filter :set_scopes, :only => [:create]

        resource_description do
          name 'Restaurants > Staff Kinds'
          short_description 'All about staff kinds of restaurants'
          path '/restaurants/:id/staff_kinds'
          description 'The Restaurant Staff Kinds endpoint lets you create new staff kinds for a restaurants.' +
                          'Only a user with the right scope can create staff kinds.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/staff_kinds', 'All the staff kinds of a restaurant'
        description "Fetches all the staff kinds of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants staff_kinds], :index, format }

        def index
          @staff_kinds = @restaurant.staff_kinds
          respond_with @staff_kinds
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/staff_kinds', 'Create a staff kind for a restaurant'
        description "Creates a staff kind for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_staff_kind, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants staff_kinds], :create, format }

        def create
          @staff_kind = create_staff_kind @restaurant, @staff_kind_scopes
          respond_with @staff_kind, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
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
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end