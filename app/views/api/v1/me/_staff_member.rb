object @staff_member => :staff_member

attributes :id, :name

node :avatar do |staff_member|
  staff_member.identity.avatar.relative_path_url
end

node :staff_kind do |staff_member|
  partial('api/v1/me/_staff_kind', :object => staff_member.staff_kind)
end