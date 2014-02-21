module Api
  module V1
    class MeController < BaseController

      doorkeeper_for :index, :scopes => [:basic]

      resource_description do
        name 'Me'
        short_description 'Everything about the currently logged-in user'
        path '/me'
        description 'All around the currently logged-in user. Use this resource to interact with the currently logged-in users profile.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :GET, '/me', 'Profile of the currently logged-in user'
      description 'Fetches the profile of the currently logged-in user, based on the OAuth Access Token provided. ||basic||'
      formats [:json, :xml]
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.json")
      example File.read("#{Rails.root}/public/docs/api/v1/me/index.xml")
      def index
        respond_with @user
      end

    end
  end
end