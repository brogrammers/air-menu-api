object @group => :group

attributes :id, :name

node :device do |group|
  partial('api/v1/groups/_device', :object => group.device)
end