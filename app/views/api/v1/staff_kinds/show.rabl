object @staff_kind => :staff_kind

attributes :id, :name, :accept_orders, :accept_order_items

node :restaurant do |staff_kind|
  partial('api/v1/staff_kinds/_restaurant', :object => staff_kind.restaurant)
end

node :scopes do |staff_kind|
  partial('api/v1/staff_kinds/_scope', :object => staff_kind.scopes)
end