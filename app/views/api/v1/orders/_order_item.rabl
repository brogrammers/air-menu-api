object @order_item => :order_item

attributes :id, :comment, :count, :state, :approved_time, :declined_time, :start_prepare_time, :end_prepare_time, :served_time

node :menu_item do |order_item|
    partial('api/v1/orders/_menu_item', :object => order_item.menu_item)
end