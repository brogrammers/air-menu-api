module Api
  module Oauth2
    class BaseController < ApplicationController
      include Api::V1::BaseHelper

      resource_description do
        api_version 'oauth2'
        app_info File.read("#{Rails.root}/doc/oauth2.txt")
        api_base_url '/api/oauth2'
      end

    end
  end
end