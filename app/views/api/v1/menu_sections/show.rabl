object @menu_section => :menu_section

attributes :id, :name, :description

node :staff_kind do |menu_section|
  partial('api/v1/menu_sections/_staff_kind', :object => menu_section.staff_kind)
end