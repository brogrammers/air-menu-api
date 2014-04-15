module Api
  module V1
    class MenuItemsController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :basic, :user]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_menus]

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

      api :PUT, '/menu_items/:id', 'Update a menu item in the system'
      description 'Updates a menu item in the system. ||admin basic update_menus||'
      formats [:json, :xml]
      param :name, String, :desc => 'Name of Menu Item'
      param :description, String, :desc => 'Description of Menu Item'
      param :price, Float, :desc => 'Price of Menu Item'
      param :currency, ['EUR'], :desc => 'Currency of Menu Item'
      param :staff_kind_id, String, :desc => 'Staff Kind handling this menu section'
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/update.xml")
      def update
        @menu_item.name = params[:name] || @menu_item.name
        @menu_item.description = params[:description] || @menu_item.description
        @menu_item.price = params[:price] || @menu_item.price
        @menu_item.currency = params[:currency] || @menu_item.currency
        @menu_item.staff_kind = @staff_kind if @staff_kind
        @menu_item.save!
        respond_with @menu_item
      end

      api :DELETE, '/menu_items/:id', 'Delete a menu item in the system'
      description 'Deletes a menu item in the system. ||admin basic delete_menus||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/destroy.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menu_items/destroy.xml")
      def destroy
        @menu_item.destroy
        respond_with @menu_item
      end

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