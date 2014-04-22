module Api
  module V1
    class MenusController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :basic, :user],
          :update => [:admin, :owner, :update_menus],
          :destroy => [:admin, :owner, :delete_menus]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

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

      ################################################################################################################

      api :GET, '/menus', 'All the menus in the system'
      description "Fetches all the menus in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menus], :index, format }

      def index
        @menus = Menu.all
        respond_with @menus
      end

      ################################################################################################################

      api :GET, '/menus/:id', 'Get a menu in the system'
      description "Fetches all the menus in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menus], :show, format }

      def show
        respond_with @menu
      end

      ################################################################################################################

      api :PUT, '/menus/:id', 'Update a menu in the system'
      description "Updates all the menus in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param :active, :bool, :desc => 'Make menu active. ||owner add_active_menus||'
      FORMATS.each { |format| example BaseController.example_file %w[menus], :update, format }

      def update
        if params[:active] and (scope_exists? 'add_active_menus' or scope_exists? 'owner')
          @menu.restaurant.active_menu_id = @menu.id
          @menu.restaurant.save!
        end
        respond_with @menu
      end

      ################################################################################################################

      api :DELETE, '/menus/:id', 'Get a menu in the system'
      description "Fetches all the menus in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[menus], :destroy, format }

      def destroy
        @menu.destroy
        respond_with @menu
      end

      ################################################################################################################

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