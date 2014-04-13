object @user => :me

attributes :id, :name, :unread_count, :phone

node :type do |user|
    user.type
end

node :identity do |user|
    partial('api/v1/me/_identity', :object => user.identity)
end

node :current_orders do |user|
    partial('api/v1/me/_order', :object => user.current_orders)
end

node :company do |user|
  partial('api/v1/me/_company', :object => user.company) if user.company
end

node :scopes do |user|
    @scopes
end