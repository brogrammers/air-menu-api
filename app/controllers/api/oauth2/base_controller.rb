module Api
  module Oauth2
    class BaseController < ApplicationController

      resource_description do
        api_version 'oauth2'
        app_info 'OAuth 2.0 Documentation. ' +
                     'Getting Started'
        api_base_url '/api/oauth2'
      end

    end
  end
end