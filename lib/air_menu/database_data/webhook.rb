#encoding: utf-8

module AirMenu
  class DatabaseData
    WEBHOOK = [
        {
            :on_action => 'show',
            :on_method => 'api/v1/restaurants',
            :host => 'http://localhost:3001',
            :path => '/api/v1/me',
            :params => { 'key' => 'value' }.to_json,
            :headers => { 'Content-Type' => 'application/json' }.to_json,
            :restaurant_id => 1
        }
    ]
  end
end