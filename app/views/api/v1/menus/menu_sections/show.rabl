object @menu_section => :menu_section

attributes :id, :name, :description

node :menu_items do |menu_section|
    partial('api/v1/menus/menu_sections/_menu_item', :object => menu_section.menu_items)
end