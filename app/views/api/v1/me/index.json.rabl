object @user => :me

attributes :id, :name

node :identity do |user|
    partial('api/v1/me/_identity', :object => user.identity)
end