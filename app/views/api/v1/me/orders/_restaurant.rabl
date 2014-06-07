object @restaurant => :restaurant

attributes :id, :name

node :avatar do |restaurant|
  restaurant.avatar.relative_path_url
end