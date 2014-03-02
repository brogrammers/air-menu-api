module Api
  module V1
    module Restaurants
      class StaffKindsController < BaseController

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_ownership, :only => [:index, :create]

        doorkeeper_for :index, :scopes => [:owner, :get_staff_kinds]
        doorkeeper_for :create, :scopes => [:owner, :create_staff_kinds]

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

        api :GET, '/restaurants/:id/staff_kinds', 'All the staff kinds of a restaurant'
        description 'Fetches all the staff kinds of a restaurant. ||owner get_staff_kinds||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/staff_kinds/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/staff_kinds/index.xml")
        def index
          @staff_kinds = @restaurant.staff_kinds
          respond_with @staff_kinds
        end

        api :POST, '/restaurants/:id/staff_kinds', 'Create a staff kind for a restaurant'
        description 'Creates a staff kind for a restaurant. ||owner create_staff_kinds||'
        formats [:json, :xml]
        param :name, String, :desc => 'Staff kind name', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/staff_kinds/create.json")
        example File.read("#{Rails.root}/public/docs/api/v1/restaurants/staff_kinds/create.xml")
        def create
          @staff_kind = create_staff_kind @restaurant
          respond_with @staff_kind
        end

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if !@user.owns @restaurant and !scope_exists? 'admin'
        end

      end
    end
  end
end