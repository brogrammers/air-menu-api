object @order => :order

attributes :id, :state, :approved_time, :served_time, :cancelled_time, :table_number

node :restaurant do |order|
    partial('api/v1/me/_restaurant', :object => order.restaurant)
end

node :order_item do |order|
    partial('api/v1/me/_order_item', :object => order.order_items)
end