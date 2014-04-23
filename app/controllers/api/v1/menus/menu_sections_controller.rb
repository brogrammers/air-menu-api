module Api
  module V1
    module Menus
      class MenuSectionsController < BaseController
        SCOPES = {
            :index => [:admin, :user, :basic],
            :create => [:admin, :owner, :add_menus, :add_active_menus]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_menu, :only => [:index, :create]
        before_filter :check_ownership, :only => [:create]
        before_filter :check_active_menu, :only => [:index, :create]
        before_filter :set_staff_kind, :only => [:create]

        resource_description do
          name 'Menus > Menu Sections'
          short_description 'All about menu sections of a menu'
          path '/menus/:id/menu_sections'
          description 'The Menu Menu Sections endpoint lets you create new menu sections for a menu.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/menus/:id/menu_sections', 'All the menu sections in a menu'
        description "Fetches all the menu sections in a menu. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[menus menu_sections], :index, format }

        def index
          @menu_sections = @menu.menu_sections
          respond_with @menu_sections
        end

        ################################################################################################################

        api :POST, '/menus/:id/menu_sections', 'Create a menu sections for a menu'
        description "Creates a menu section for a menu. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_menu_section, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[menus menu_sections], :create, format }

        def create
          @menu_section = create_menu_section @menu
          respond_with @menu_section, :status => :created
        end

        ################################################################################################################

        private

        def set_menu
          @menu = Menu.find params[:menu_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Menu'
        end

        def set_staff_kind
          @staff_kind = StaffKind.find params[:staff_kind_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'StaffKind'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(@menu.active? && !@user.owns(@menu))
        end

        def check_active_menu
          render_model_not_found 'Menu' if not_admin_and?(!@menu.active? && !@user.owns(@menu))
        end

      end
    end
  end
end