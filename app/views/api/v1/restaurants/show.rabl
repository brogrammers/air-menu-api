object @restaurant => :restaurant

attributes :id, :name, :loyalty, :remote_order, :conversion_rate

node :address do |restaurant|
    partial('api/v1/restaurants/_address', :object => restaurant.address)
end

node :menu do |restaurant|
    partial('api/v1/restaurants/_menu', :object => restaurant.active_menu) if restaurant.active_menu
end

node :location do |restaurant|
  partial('api/v1/restaurants/_location', :object => restaurant.location)
end