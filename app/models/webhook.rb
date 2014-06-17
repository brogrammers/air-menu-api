require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'air_menu')

class Webhook < ActiveRecord::Base
  include AirMenu::WebhookHelper unless Rails.env == 'test'

  belongs_to :restaurant

  def perform!
    unless Rails.env == 'test'
      conn = connection self.host
      conn.get self.path, self.proper_params, self.proper_headers
    end
  end

  def proper_params
    JSON.parse(self.params)
  rescue JSON::ParserError
    {}
  end

  def proper_headers
    JSON.parse(self.headers)
  rescue JSON::ParserError
    {}
  end

end