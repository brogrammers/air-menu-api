class CreditCard < ActiveRecord::Base
  belongs_to :user

  def obscured_number
    result = ''
    12.times { result << 'X' }
    result <<  self.number[12..16]
  end

  validates :number, length: { is: 16 }
end