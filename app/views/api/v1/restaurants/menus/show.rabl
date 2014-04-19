object @menu => :menu

attributes :id, :name

node :active do |menu|
  menu.active?
end