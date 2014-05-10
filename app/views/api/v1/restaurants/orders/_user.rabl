object @user => :user

node :avatar do |user|
  user.identity.avatar.relative_path_url
end

attributes :id, :name, :type