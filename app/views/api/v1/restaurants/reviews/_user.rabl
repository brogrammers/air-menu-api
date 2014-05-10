object @user => :user

attributes :id, :name

node :avatar do |user|
  user.identity.avatar.relative_path_url
end