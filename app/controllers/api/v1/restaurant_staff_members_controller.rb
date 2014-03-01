module Api
  module V1
    class RestaurantStaffMembersController < BaseController

      before_filter :set_restaurant, :only => [:index, :create]
      before_filter :set_staff_kind, :only => [:create]
      before_filter :check_ownership, :only => [:index, :create]

      doorkeeper_for :index, :scopes => [:owner, :get_staff_members]
      doorkeeper_for :create, :scopes => [:owner, :create_staff_members]

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

      api :GET, '/restaurants/:id/staff_members', 'All the staff members of a restaurant'
      description 'Fetches all the staff members of a restaurant. ||owner get_staff_members||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_staff_members/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_staff_members/index.xml")
      def index
        @staff_members = @restaurant.staff_members
        respond_with @staff_members
      end

      api :POST, '/restaurants/:id/staff_members', 'Create a staff member for a restaurant'
      description 'Creates a staff member for a restaurant. ||owner create_staff_members||'
      formats [:json, :xml]
      param :name, String, 'Staff Member name', :required => true
      param :username, String, 'Staff Member username', :required => true
      param :password, String, 'Staff Member password', :required => true
      param :email, String, 'Staff Member email', :required => true
      param :staff_kind_id, String, 'Staff Members staff kind id', :required => true
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_staff_members/create.json")
      example File.read("#{Rails.root}/public/docs/api/v1/restaurant_staff_members/create.xml")
      def create
        @staff_member = create_staff_member @restaurant, @staff_kind
        respond_with @staff_member
      end

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
        render_forbidden 'ownership_failure' if !@user.owns @restaurant and !scope_exists? 'admin'
      end

    end
  end
end