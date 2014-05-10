module Api
  module V1
    class MenuItemsController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :basic, :user],
          :update => [:admin, :owner, :update_menus],
          :destroy => [:admin, :owner, :delete_menus]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_menu_item, :only => [:show, :update, :destroy]
      before_filter :set_staff_kind, :only => [:update]
      before_filter :check_ownership, :only => [:update, :destroy]
      before_filter :check_active_menu_item, :only => [:show, :update, :destroy]

      resource_description do
        name 'Menu Items'
        short_description 'All about menu items in the system'
        path '/menu_items'
        description 'The Menu Menu Items endpoint lets you inspect menu items in the system.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/menu_items', 'All the menu items in the system'
      description "Fetches all the menu items in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menu_items], :index, format }

      def index
        @menu_items = MenuItem.all
        respond_with @menu_items
      end

      ################################################################################################################

      api :GET, '/menu_items/:id', 'Get a menu item in the system'
      description "Fetches a menu item in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menu_items], :show, format }

      def show
        respond_with @menu_item
      end

      ################################################################################################################

      api :PUT, '/menu_items/:id', 'Update a menu item in the system'
      description "Updates a menu item in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_menu, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[menu_items], :update, format }

      def update
        @menu_item = update_menu_item @menu_item, @staff_kind
        respond_with @menu_item
      end

      ################################################################################################################

      api :DELETE, '/menu_items/:id', 'Delete a menu item in the system'
      description "Deletes a menu item in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menu_items], :destroy, format }

      def destroy
        @menu_item.destroy
        respond_with @menu_item
      end

      ################################################################################################################

      private

      def set_menu_item
        @menu_item = MenuItem.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'MenuItem'
      end

      def set_staff_kind
        @staff_kind = StaffKind.find params[:staff_kind_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffKind'
      end

      def check_ownership
        render_model_not_found 'MenuItem' if not_admin_and?(!@user.owns(@menu_item))
      end

      def check_active_menu_item
        render_model_not_found 'MenuItem' if not_admin_and?(!@menu_item.active? && !@user.owns(@menu_item))
      end

    end
  end
end