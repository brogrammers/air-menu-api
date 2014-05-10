object @user => :user

attributes :id, :name

node :avatar do |user|
  user.identity.avatar.relative_path_url
end

node :identity do |user|
  partial('api/v1/users/_identity', :object => user.identity)
end

