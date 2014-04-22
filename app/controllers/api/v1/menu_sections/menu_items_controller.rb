module Api
  module V1
    module MenuSections
      class MenuItemsController < BaseController
        SCOPES = {
            :index => [:admin, :user, :basic],
            :create => [:admin, :owner, :add_menus, :add_active_menus]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_menu_section, :only => [:index, :create]
        before_filter :check_active_menu_section, :only => [:index, :create]
        before_filter :check_ownership, :only => [:create]
        before_filter :set_staff_kind, :only => [:create]

        resource_description do
          name 'Menu Sections > Menu Items'
          short_description 'All about menu items within menu sections'
          path '/menu_sections/:id/menu_items'
          description 'The Menu Section Menu Items endpoint lets you create new menu items for a menu section.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/menu_sections/:id/menu_items', 'All the menu items within a menu section'
        description "Fetches all the menu items within a menu section. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[menu_sections menu_items], :index, format }

        def index
          @menu_items = @menu_section.menu_items
          respond_with @menu_items
        end

        ################################################################################################################

        api :POST, '/menu_sections/:id/menu_items', 'Create menu items within a menu section'
        description "Creates a menu item within a menu section. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_menu_item, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[menu_sections menu_items], :create, format }

        def create
          @menu_item = MenuItem.new
          @menu_item.name = params[:name]
          @menu_item.description = params[:description]
          @menu_item.price = params[:price]
          @menu_item.currency = params[:currency]
          @menu_item.menu_section = @menu_section
          @menu_item.staff_kind = @staff_kind if @staff_kind
          @menu_section.menu_items << @menu_item
          @menu_item.save!
          respond_with @menu_item, :status => :created
        end

        ################################################################################################################

        private

        def set_menu_section
          @menu_section = MenuSection.find params[:menu_section_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'MenuSection'
        end

        def set_staff_kind
          @staff_kind = StaffKind.find params[:staff_kind_id]
        rescue ActiveRecord::RecordNotFound

        end

        def check_active_menu_section
          render_model_not_found 'MenuSection' if not_admin_and?(!@menu_section.active? && !@user.owns(@menu_section))
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(@menu_section.active? && !@user.owns(@menu_section))
        end

      end
    end
  end
end