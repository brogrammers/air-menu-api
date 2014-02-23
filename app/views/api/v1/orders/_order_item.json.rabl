object @order_item => :order_item

attributes :id, :comment, :count, :served

node :menu_item do |order_item|
    partial('api/v1/order_items/_menu_item', :object => order_item.menu_item)
end