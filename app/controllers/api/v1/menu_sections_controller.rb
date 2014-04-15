module Api
  module V1
    class MenuSectionsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :basic, :user]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_menus]
      doorkeeper_for :destroy, :scopes => [:admin, :owner, :delete_menus]

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

      api :GET, '/menu_sections', 'All the menu sections in the system'
      description 'Fetches all the menus in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/index.xml")
      def index
        @menu_sections = MenuSection.all
        respond_with @menu_sections
      end

      api :GET, '/menu_sections/:id', 'Get a menu section in the system'
      description 'Fetches a menu section in the system. ||admin basic user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/show.xml")
      def show
        respond_with @menu_section
      end

      api :PUT, '/menu_sections/:id', 'Update a menu section in the system'
      description 'Updates a menu section in the system. ||admin owner update_menus||'
      formats [:json, :xml]
      param :name, String, :desc => 'Name of Menu Section'
      param :description, String, :desc => 'Description of Menu Section'
      param :staff_kind_id, String, :desc => 'Staff Kind handling this menu section'
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/update.xml")
      def update
        @menu_section.name = params[:name] || @menu_sections.name
        @menu_section.description = params[:description] || @menu_sections.description
        @menu_section.staff_kind = @staff_kind
        @menu_section.save!
        respond_with @menu_section
      end

      api :DELETE, '/menu_sections/:id', 'Delete a menu section in the system'
      description 'Deletes a menu section in the system. ||admin owner delete_menus||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/update.xml")
      def destroy
        @menu_section.destroy
        respond_with @menu_section
      end

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