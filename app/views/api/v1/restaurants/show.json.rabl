object @restaurant => :restaurant

attributes :id, :name, :loyalty, :remote_order, :conversion_rate

node :address do |restaurant|
    partial('api/v1/restaurants/_address', :object => restaurant.address)
end