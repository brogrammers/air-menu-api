module Api
  module Oauth2
    class BaseController < ApplicationController

      resource_description do
        api_version 'oauth2'
        app_info File.read("#{Rails.root}/public/docs/api/oauth2/desc.txt")
        api_base_url '/api/oauth2'
      end

    end
  end
end