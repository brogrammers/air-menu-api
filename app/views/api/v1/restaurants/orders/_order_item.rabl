object @order_item => :order_item

attributes :id, :comment, :count, :state, :approved_time, :declined_time, :start_prepare_time, :end_prepare_time, :served_time

node :menu_item do |order_item|
  partial('api/v1/restaurants/orders/_menu_item', :object => order_item.menu_item)
end

node :staff_member do |order_item|
  partial('api/v1/restaurants/orders/_staff_member', :object => order_item.staff_member)
end