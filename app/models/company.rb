class Company < ActiveRecord::Base
  has_one :address, :as => :contactable
  has_many :restaurants

  validates :name, :website, presence: true
end