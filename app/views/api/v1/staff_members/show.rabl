object @staff_member => :staff_member

attributes :id, :name

node :identity do |staff_member|
  partial('api/v1/staff_members/_identity', :object => staff_member.identity)
end

node :staff_kind do |staff_member|
  partial('api/v1/staff_members/_staff_kind', :object => staff_member.staff_kind)
end

node :restaurant do |staff_member|
  partial('api/v1/staff_members/_restaurant', :object => staff_member.restaurant)
end