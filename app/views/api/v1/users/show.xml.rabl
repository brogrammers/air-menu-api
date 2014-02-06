object @user => :user

attributes :id, :name

node :identity do |user|
    partial('api/v1/users/_identity', :object => user.identity)
end