object @company => :company

attributes :id, :name, :user_id

node :address do |company|
  partial('api/v1/me/_address', :object => company.address)
end