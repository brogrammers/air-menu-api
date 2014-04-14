module Api
  module V1
    class BaseController < ApplicationController
      include BaseHelper

      resource_description do
        api_version 'v1'
        app_info File.read("#{Rails.root}/doc/v1.txt")
        api_base_url '/api/v1'
      end

    end
  end
end