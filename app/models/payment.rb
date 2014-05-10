class Payment < ActiveRecord::Base
  belongs_to :order
  belongs_to :credit_card

  def type
    self.credit_card ? :card : :cash
  end
end