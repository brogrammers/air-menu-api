object @group => :group

attributes :id, :name

node :device do |group|
  partial('api/v1/restaurants/groups/_device', :object => group.device)
end

node :staff_members do |group|
  partial('api/v1/restaurants/groups/_staff_member', :object => group.staff_members)
end