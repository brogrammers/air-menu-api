object @menu_section => :menu_section

attributes :id, :name, :description

node :menu_items do |menu_section|
    partial('api/v1/menus/menu_sections/_menu_item', :object => menu_section.menu_items)
end

node :staff_kind do |menu_section|
  partial('api/v1/menus/menu_sections/_staff_kind', :object => menu_section.staff_kind)
end