module Api
  module V1
    module Restaurants
      class GroupsController < BaseController
        SCOPES = {
            :index => [:admin, :owner, :get_groups],
            :create => [:admin, :owner, :create_groups]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]

        resource_description do
          name 'Restaurants > Groups'
          short_description 'All about groups of restaurants'
          path '/restaurants/:id/groups'
          description 'The Restaurant Groups endpoint lets you create new groups for a restaurants.' +
                          'Only a users with the right scope can create groups.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/groups', 'All the groups of a restaurant'
        description "Fetches all the groups of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants groups], :index, format }

        def index
          @groups = @restaurant.groups
          respond_with @groups
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/groups', 'Create a group for a restaurant'
        description "Creates a group for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_group, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants groups], :create, format }

        def create
          @group = create_group @restaurant
          respond_with @group, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@restaurant))
        end

      end
    end
  end
end