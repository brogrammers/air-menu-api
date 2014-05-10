object @restaurant => :restaurant

attributes :id, :name, :description, :rating, :loyalty, :remote_order, :conversion_rate

node :avatar do |restaurant|
  restaurant.avatar.relative_path_url
end

node :address do |restaurant|
    partial('api/v1/restaurants/_address', :object => restaurant.address)
end

node :menu do |restaurant|
    partial('api/v1/restaurants/_menu', :object => restaurant.active_menu) if restaurant.active_menu
end

node :location do |restaurant|
  partial('api/v1/restaurants/_location', :object => restaurant.location)
end

node :opening_hours do |restaurant|
  partial('api/v1/restaurants/_opening_hour', :object => restaurant.opening_hours)
end