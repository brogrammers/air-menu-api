object @staff_member => :staff_member

attributes :id, :name

node :avatar do |staff_member|
  staff_member.identity.avatar.relative_path_url
end

node :identity do |staff_member|
  partial('api/v1/restaurants/staff_kinds/_identity', :object => staff_member.identity)
end