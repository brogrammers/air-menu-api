module Api
  module V1
    class MenuSectionMenuItemsController < BaseController

      before_filter :set_menu_section, :only => [:index, :create]
      before_filter :check_active_menu_section, :only => [:index]
      before_filter :check_ownership, :only => [:create]

      doorkeeper_for :index, :scopes => [:user]
      doorkeeper_for :create, :scopes => [:owner, :add_menus, :add_active_menus]

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

      api :GET, '/menu_sections/:id/menu_items', 'All the menu items within a menu section'
      description 'Fetches all the menu items within a menu section. ||user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/index.xml")
      def index
        respond_with @menu_section.menu_items
      end

      api :POST, '/menu_sections/:id/menu_items', 'Create menu items within a menu section'
      description 'Creates a menu item within a menu section. ||owner add_menus add_active_menus||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/show.xml")
      def create
        @menu_item = MenuItem.new
        @menu_item.name = params[:name]
        @menu_item.description = params[:description]
        @menu_item.price = params[:price]
        @menu_item.currency = params[:currency]
        @menu_item.menu_section = @menu_section
        @menu_section.menu_items << @menu_item
        @menu_item.save!
        respond_with @menu_item
      end

      private

      def set_menu_section
        @menu_section = MenuSection.find params[:menu_section_id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Menu Section'
      end

      def check_active_menu_section
        render_model_not_found 'Menu Section' if !@menu_section.active? and !@user.owns @menu_section and !scope_exists? 'admin'
      end

      def check_ownership
        render_forbidden if @menu_section.active? and !@user.owns @menu_section and !scope_exists? 'admin'
        check_active_menu_section
      end

    end
  end
end