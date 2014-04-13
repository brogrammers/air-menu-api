object @user => :me

attributes :id, :name, :unread_count

node :type do |user|
    user.type
end

node :identity do |user|
    partial('api/v1/me/_identity', :object => user.identity)
end

node :order do |user|
    partial('api/v1/me/_order', :object => user.current_orders.first)
end

node :company do |user|
  partial('api/v1/me/_company', :object => user.company) if user.company
end

node :scopes do |user|
    @scopes
end