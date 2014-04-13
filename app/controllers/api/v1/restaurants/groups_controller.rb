module Api
  module V1
    module Restaurants
      class GroupsController < BaseController

        doorkeeper_for :index, :scopes => [:admin, :owner, :get_groups]
        doorkeeper_for :create, :scopes => [:admin, :owner, :create_groups]

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

        api :GET, '/restaurants/:id/groups', 'All the groups of a restaurant'
        description 'Fetches all the groups of a restaurant. ||admin owner get_groups||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/groups/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/groups/index.xml")
        def index
          @groups = @restaurant.groups
          respond_with @groups
        end

        api :POST, '/restaurants/:id/groups', 'Create a group for a restaurant'
        description 'Creates a group for a restaurant. ||admin owner create_groups||'
        formats [:json, :xml]
        param :name, String, 'Group name', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/groups/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/groups/create.xml")
        def create
          @group = create_group @restaurant
          respond_with @group, :status => :created
        end

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