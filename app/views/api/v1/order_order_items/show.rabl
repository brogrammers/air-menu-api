object @order_item => :order_item

attributes :id, :comment, :count, :served

node :order do |order_item|
    partial('api/v1/order_order_items/_order', :object => order_item.order)
end

node :menu_item do |order_item|
    partial('api/v1/order_order_items/_menu_item', :object => order_item.menu_item)
end