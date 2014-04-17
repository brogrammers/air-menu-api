module Api
  module V1
    class MenusController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:admin, :basic, :user]
      doorkeeper_for :update, :scopes => [:admin, :owner, :update_menus]
      doorkeeper_for :delete, :scopes => [:admin, :owner, :delete_menus]

      before_filter :set_menu, :only => [:show, :update, :destroy]
      before_filter :check_active_menu, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:update, :destroy]

      resource_description do
        name 'Menus'
        short_description 'All about menus in the system'
        path '/menus'
        description 'The Menu endpoint lets you create new menus for a restaurant.' +
                        'Only an owner or a staff member with the appropriate scope can create restaurants.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/menus', 'All the menus in the system'
      description 'Fetches all the menus in the system. ||admin||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menus/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menus/index.xml")
      def index
        @menus = Menu.all
        respond_with @menus
      end

      api :GET, '/menus/:id', 'Get a menu in the system'
      description 'Fetches all the menus in the system. ||admin basic user||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menus/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menus/show.xml")
      def show
        respond_with @menu
      end

      api :PUT, '/menus/:id', 'Update a menu in the system'
      description 'Updates all the menus in the system. ||admin owner update_menus||'
      formats [:json, :xml]
      param :active, String, :desc => 'Make menu active. ||owner add_active_menus||'
      example File.read("#{Rails.root}/public/docs/api/v1/menus/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menus/update.xml")
      def update
        if params[:active] and (scope_exists? 'add_active_menus' or scope_exists? 'owner')
          @menu.restaurant.active_menu_id = @menu.id
          @menu.restaurant.save!
        end
        respond_with @menu
      end

      api :DELETE, '/menus/:id', 'Get a menu in the system'
      description 'Fetches all the menus in the system. ||admin owner delete_menus||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menus/destroy.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menus/destroy.xml")
      def destroy
        @menu.destroy
        respond_with @menu
      end

      private

      def set_menu
        @menu = Menu.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Menu'
      end

      def check_ownership
        render_model_not_found 'Menu' if not_admin_and?(!@user.owns(@menu))
      end

      def check_active_menu
        render_model_not_found 'Menu' if not_admin_and?(!@menu.active? && !@user.owns(@menu))
      end

    end
  end
end