object @order => :order

attributes :id, :state, :approved_time, :served_time, :cancelled_time

node :user do |order|
    partial('api/v1/restaurants/orders/_user', :object => order.user)
end

node :restaurant do |order|
    partial('api/v1/restaurants/orders/_restaurant', :object => order.restaurant)
end