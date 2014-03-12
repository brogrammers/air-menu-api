object @user => :me

attributes :id, :name

node :type do |user|
  user.type
end

node :identity do |user|
  partial('api/v1/me/_identity', :object => user.identity)
end

node :company do |user|
  partial('api/v1/me/_company', :object => user.company)
end

node :scopes do |user|
  @scopes
end