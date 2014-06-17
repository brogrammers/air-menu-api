object @order => :order

attributes :id, :state, :approved_time, :served_time, :cancelled_time, :table_number

node :user do |order|
    partial('api/v1/restaurants/orders/_user', :object => order.user)
end

node :staff_member do |order|
  partial('api/v1/restaurants/orders/_staff_member', :object => order.staff_member)
end

node :restaurant do |order|
    partial('api/v1/restaurants/orders/_restaurant', :object => order.restaurant)
end

node :order_items do |order|
  partial('api/v1/restaurants/orders/_order_item', :object => order.order_items)
end