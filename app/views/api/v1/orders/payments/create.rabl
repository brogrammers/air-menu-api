object @payment => :payment

attributes :id, :created_at

node :type do |payment|
  payment.type if payment
end