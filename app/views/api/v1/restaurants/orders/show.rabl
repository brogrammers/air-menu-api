object @order => :order

attributes :id, :prepared, :served, :start, :end_prepared, :end_served

node :user do |order|
    partial('api/v1/restaurants/orders/_user', :object => order.user)
end

node :restaurant do |order|
    partial('api/v1/restaurants/orders/_restaurant', :object => order.restaurant)
end