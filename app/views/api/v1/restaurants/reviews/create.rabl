object @review => :review

attributes :id, :subject, :message, :rating, :created_at

node :user do |review|
  partial('api/v1/restaurants/reviews/_user', :object => review.user)
end