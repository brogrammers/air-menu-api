object @staff_member => :staff_member

node :staff_kind do |staff_member|
  partial('api/v1/me/_staff_kind', :object => staff_member.staff_kind)
end

node :restaurant do |staff_member|
  partial('api/v1/me/_restaurant', :object => staff_member.restaurant)
end