module Api
  module V1
    class MenuSectionsController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :basic, :user],
          :update => [:admin, :owner, :update_menus],
          :destroy => [:admin, :owner, :delete_menus]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_menu_section, :only => [:show, :update, :destroy]
      before_filter :set_staff_kind, :only => [:update]
      before_filter :check_ownership, :only => [:update, :destroy]
      before_filter :check_active_menu_section, :only => [:show, :update, :destroy]

      resource_description do
        name 'Menu Sections'
        short_description 'All about menu sections in the system'
        path '/menu_sections'
        description 'The Menu Sections endpoint lets you show menu sections in the system.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/menu_sections', 'All the menu sections in the system'
      description "Fetches all the menus in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menu_sections], :index, format }

      def index
        @menu_sections = MenuSection.all
        respond_with @menu_sections
      end

      ################################################################################################################

      api :GET, '/menu_sections/:id', 'Get a menu section in the system'
      description "Fetches a menu section in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menu_sections], :show, format }

      def show
        respond_with @menu_section
      end

      ################################################################################################################

      api :PUT, '/menu_sections/:id', 'Update a menu section in the system'
      description "Updates a menu section in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_menu_section, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[menu_sections], :update, format }

      def update
        @menu_section.name = params[:name] || @menu_sections.name
        @menu_section.description = params[:description] || @menu_sections.description
        @menu_section.staff_kind = @staff_kind
        @menu_section.save!
        respond_with @menu_section
      end

      ################################################################################################################

      api :DELETE, '/menu_sections/:id', 'Delete a menu section in the system'
      description "Deletes a menu section in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menu_sections], :destroy, format }

      def destroy
        @menu_section.destroy
        respond_with @menu_section
      end

      ################################################################################################################

      private

      def set_menu_section
        @menu_section = MenuSection.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'MenuSection'
      end

      def set_staff_kind
        @staff_kind = StaffKind.find params[:staff_kind_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'StaffKind'
      end

      def check_ownership
        render_model_not_found 'MenuSection' if not_admin_and?(!@user.owns(@menu_section))
      end

      def check_active_menu_section
        render_model_not_found 'MenuSection' if not_admin_and?(!@menu_section.active? && !@user.owns(@menu_section))
      end

    end
  end
end