module Api
  module V1
    class MenuSectionsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:basic, :user]

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
      description 'Fetches all the menus in the system. <b>Scopes:</b> admin'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/index.xml")
      def index
        @menu_sections = MenuSection.all
        respond_with @menu_sections
      end

      api :GET, '/menu_sections/:id', 'Get a menu in the system'
      description 'Fetches a menu section in the system. <b>Scopes:</b> basic user'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_sections/show.xml")
      def show
        @menu_section = MenuSection.find params[:id]
        respond_with @menu_section
      end

    end
  end
end