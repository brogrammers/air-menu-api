object @menu => :menu

attributes :id, :name

node :active do |menu|
  menu.active?
end

node :menu_sections do |menu|
    partial('api/v1/menus/_menu_section', :object => menu.menu_sections)
end