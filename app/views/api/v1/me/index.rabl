object @user => :me

attributes :id, :name, :unread_count, :phone

node :avatar do |user|
  user.identity.avatar.relative_path_url
end

node :type do |user|
    user.type
end

node :identity do |user|
    partial('api/v1/me/_identity', :object => user.identity)
end

node :current_orders do |user|
    partial('api/v1/me/_order', :object => user.current_orders)
end if @user.class == User

node :company do |user|
  partial('api/v1/me/_company', :object => user.company) if user.company
end

node :scopes do |user|
    @scopes
end



node :staff_member do |user|
  node :staff_kind do |user|
    partial('api/v1/me/_staff_kind', :object => user.staff_kind)
  end
end if @user.class == StaffMember