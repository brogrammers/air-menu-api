module Api
  module V1
    class MenusController < BaseController

      doorkeeper_for :index, :scopes => [:admin]
      doorkeeper_for :show, :scopes => [:basic, :user]

      resource_description do
        name 'Menus'
        short_description 'All about menus in the system'
        path '/menus'
        description 'The Restaurant endpoint lets you create new menus for a restaurant.' +
                        'Only an owner can create restaurants.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/menus', 'All the menus in the system'
      description 'Fetches all the menus in the system. <b>Scopes:</b> admin'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menus/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menus/index.xml")
      def index
        @menus = Menu.all
        respond_with @menus
      end

      api :GET, '/menus/:id', 'Get a menu in the system'
      description 'Fetches all the menus in the system. <b>Scopes:</b> basic user'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/menus/show.json")
      example File.read("#{Rails.root}/public/docs/api/v1/menus/show.xml")
      def show
        @menu = Menu.find params[:id]
        respond_with @menu
      end

    end
  end
end