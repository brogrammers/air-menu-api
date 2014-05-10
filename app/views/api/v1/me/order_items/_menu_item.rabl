object @menu_item => :menu_item

attributes :id, :name, :description, :price, :currency

node :avatar do |menu_item|
  menu_item.avatar.relative_path_url
end