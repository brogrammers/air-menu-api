object @staff_member => :staff_member

attributes :id, :name

node :avatar do |staff_member|
  staff_member.identity.avatar.relative_path_url
end

node :identity do |staff_member|
  partial('api/v1/staff_members/_identity', :object => staff_member.identity)
end

node :staff_kind do |staff_member|
  partial('api/v1/staff_members/_staff_kind', :object => staff_member.staff_kind)
end

node :restaurant do |staff_member|
  partial('api/v1/staff_members/_restaurant', :object => staff_member.restaurant)
end

node :device do |staff_member|
  partial('api/v1/staff_members/_device', :object => staff_member.device)
end

node :group do |staff_member|
  partial('api/v1/staff_members/_group', :object => staff_member.group)
end