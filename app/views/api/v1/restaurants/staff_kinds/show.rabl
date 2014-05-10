object @staff_kind => :staff_kind

attributes :id, :name, :accept_orders, :accept_order_items

node :scopes do |staff_kind|
  partial('api/v1/restaurants/staff_kinds/_scope', :object => staff_kind.scopes)
end

node :staff_members do |staff_kind|
  partial('api/v1/restaurants/staff_kinds/_staff_member', :object => staff_kind.staff_members)
end