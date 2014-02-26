object @order => :order

attributes :id, :prepared, :served, :start, :end_prepared, :end_served

node :restaurant do |order|
    partial('api/v1/me/_restaurant', :object => order.restaurant)
end

node :order_items do |order|
    partial('api/v1/me/_order_item', :object => order.order_items)
end