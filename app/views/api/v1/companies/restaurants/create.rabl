object @restaurant => :restaurant

attributes :id, :name, :description, :rating, :loyalty, :remote_order, :conversion_rate

node :address do |restaurant|
    partial('api/v1/companies/restaurants/_address', :object => restaurant.address)
end

node :location do |restaurant|
  partial('api/v1/companies/restaurants/_location', :object => restaurant.location)
end