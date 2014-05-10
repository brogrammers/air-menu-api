object @review => :review

attributes :id, :subject, :message, :rating

node :user do |review|
  partial('api/v1/restaurants/reviews/_user', :object => review.user)
end