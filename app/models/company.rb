class Company < ActiveRecord::Base
  has_one :address, :as => :contactable

  validates :name, :website, presence: true
end