object @staff_member => :staff_member

node :avatar do |staff_member|
  staff_member.identity.avatar.relative_path_url
end

attributes :id, :name