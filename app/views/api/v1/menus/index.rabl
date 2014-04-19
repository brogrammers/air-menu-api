collection @menus, :root => 'menus', :object_root => ''

attributes :id, :name

node :active do |menu|
  menu.active?
end