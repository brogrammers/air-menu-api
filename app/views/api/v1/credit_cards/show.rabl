object @credit_card => :credit_card

attributes :id

node :number do |credit_card|
  credit_card.obscured_number
end

attributes :card_type, :month, :year