object @staff_member => :staff_member

attributes :id, :name

node :avatar do |staff_member|
  staff_member.identity.avatar.relative_path_url
end

node :device do |staff_member|
  partial('api/v1/groups/staff_members/_device', :object => staff_member.device)
end