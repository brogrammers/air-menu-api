module Api
  module V1
    class StaffKindsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :owner, :get_staff_kinds]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_staff_kinds]
      doorkeeper_for :destroy, :scopes => [:admin, :owner, :delete_staff_kinds]

      before_filter :set_staff_kind, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:show, :update, :destroy]
      before_filter :set_scopes, :only => [:update]

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

      api :PUT, '/staff_kinds/:id', 'Change a staff kind in the system'
      description 'Changes a staff kind in the system. ||admin owner update_staff_kinds||'
      formats [:json, :xml]
      param :name, String, :desc => 'New Staff Kind name'
      param :scopes, String, :desc => 'Staff Kind Permissions'
      param :accept_orders, :bool, :desc => 'Staff kind can accept orders'
      param :accept_order_items, :bool, :desc => 'Staff kind can accept order items'
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/update.xml")
      def update
        @staff_kind.name = params[:name] || @staff_kind.name
        @staff_kind.accept_orders = params[:accept_orders] unless params[:accept_orders].nil?
        @staff_kind.accept_order_items = params[:accept_order_items] unless params[:accept_order_items].nil?
        @staff_kind.empty_scopes if @staff_kind_scopes.size > 0
        @staff_kind_scopes.each do |scope|
          @staff_kind.scopes << scope
        end
        @staff_kind.save!
        respond_with @staff_kind
      end

      api :DELETE, '/staff_kinds/:id', 'Delete a staff kind in the system'
      description 'Deletes a staff kind in the system. ||admin owner delete_staff_kinds||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/destroy.json")
      example File.read("#{Rails.root}/public/docs/api/v1/staff_kinds/destroy.xml")
      def destroy
        @staff_kind.destroy
        respond_with @staff_kind
      end

      private

      def set_staff_kind
        @staff_kind = StaffKind.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffKind'
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
        render_model_not_found 'StaffKind' if not_admin_and?(!@user.owns(@staff_kind.restaurant))
      end

    end
  end
end