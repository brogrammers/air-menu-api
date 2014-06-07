object @user => :user

attributes :id, :name, :type

node :avatar do |user|
  user.identity.avatar.relative_path_url
end