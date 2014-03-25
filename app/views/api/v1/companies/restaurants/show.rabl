object @restaurant => :restaurant

attributes :id, :name, :loyalty, :remote_order, :conversion_rate

node :address do |restaurant|
    partial('api/v1/companies/restaurants/_address', :object => restaurant.address)
end

node :menu do |restaurant|
    partial('api/v1/companies/restaurants/_menu', :object => Menu.find(restaurant.active_menu_id)) if restaurant.active_menu_id
end