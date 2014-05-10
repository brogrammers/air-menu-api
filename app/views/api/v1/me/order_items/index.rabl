collection @order_items, :root => 'order_items', :object_root => ''

attributes :id, :comment, :count, :state, :approved_time, :declined_time, :start_prepare_time, :end_prepare_time, :served_time

node :order do |order_item|
  partial('api/v1/me/order_items/_order', :object => order_item.order)
end

node :menu_item do |order_item|
  partial('api/v1/me/order_items/_menu_item', :object => order_item.menu_item)
end