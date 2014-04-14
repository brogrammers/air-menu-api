object @staff_member => :staff_member

attributes :id, :name

node :device do |staff_member|
  partial('api/v1/groups/staff_members/_device', :object => staff_member.device)
end