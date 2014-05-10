object @menu_item => :menu_item

attributes :id, :name, :description, :price, :currency

node :avatar do |menu_item|
  menu_item.avatar.relative_path_url
end

node :staff_kind do |menu_item|
  partial('api/v1/menu_items/_staff_kind', :object => menu_item.staff_kind)
end