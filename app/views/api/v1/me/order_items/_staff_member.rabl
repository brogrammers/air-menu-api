object @staff_member => :staff_member

attributes :id, :name

node :avatar do |staff_member|
  staff_member.identity.avatar.relative_path_url
end