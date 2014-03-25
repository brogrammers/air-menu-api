module Api
  module V1
    class MenuItemsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :basic, :user]

      before_filter :set_menu_item, :only => [:show]
      before_filter :check_active_menu_item, :only => [:show]

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

      api :GET, '/menu_items', 'All the menu items in the system'
      description 'Fetches all the menu items in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/index.xml")
      def index
        @menu_items = MenuItem.all
        respond_with @menu_items
      end

      api :GET, '/menu_items/:id', 'Get a menu item in the system'
      description 'Fetches a menu item in the system. ||admin basic user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/show.xml")
      def show
        respond_with @menu_item
      end

      private

      def set_menu_item
        @menu_item = MenuItem.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'MenuItem'
      end

      def check_active_menu_item
        render_model_not_found 'MenuItem' if not_admin_and?(!@menu_item.active? && !@user.owns(@menu_item))
      end

    end
  end
end