collection @orders, :root => 'orders', :object_root => ''

attributes :id, :state, :approved_time, :served_time, :cancelled_time, :table_number

node :user do |order|
  partial('api/v1/me/orders/_user', :object => order.user)
end

node :restaurant do |order|
  partial('api/v1/me/orders/_restaurant', :object => order.restaurant)
end