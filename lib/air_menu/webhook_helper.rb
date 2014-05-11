module AirMenu
  module WebhookHelper

    def connection(url)
      Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end

  end
end