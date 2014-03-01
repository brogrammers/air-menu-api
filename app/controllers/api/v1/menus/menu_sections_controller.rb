module Api
  module V1
    module Menus
      class MenuSectionsController < BaseController

        before_filter :set_menu, :only => [:index, :create]
        before_filter :check_ownership, :only => [:create]
        before_filter :check_active_menu, :only => [:index, :create]

        doorkeeper_for :index, :scopes => [:user]
        doorkeeper_for :create, :scopes => [:owner, :add_menus, :add_active_menus]

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

        api :GET, '/menus/:id/menu_sections', 'All the menu sections in a menu'
        description 'Fetches all the menu sections in a menu. ||user||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/index.xml")
        def index
          respond_with @menu.menu_sections
        end

        api :POST, '/menus/:id/menu_sections', 'Create a menu sections for a menu'
        description 'Creates a menu section for a menu. ||owner add_menus add_active_menus||'
        formats [:json, :xml]
        param :name, String, :desc => 'Name of Menu Section', :required => true
        param :description, String, :desc => 'Description of Menu Section', :required => true
        example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/show.json")
        example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/show.xml")
        def create
          @menu_section = MenuSection.new
          @menu_section.name = params[:name]
          @menu_section.description = params[:description]
          @menu.menu_sections << @menu_section
          @menu_section.menu = @menu
          @menu_section.save!
          respond_with @menu_section
        end

        private

        def set_menu
          @menu = Menu.find params[:menu_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Menu'
        end

        def check_active_menu
          render_model_not_found 'Menu' if !@menu.active? and !@user.owns @menu and !scope_exists? 'admin'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if @menu.active? and !@user.owns @menu and !scope_exists? 'admin'
        end

      end
    end
  end
end