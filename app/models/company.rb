class Company < ActiveRecord::Base
  has_one :address, :as => :contactable
  has_many :restaurants
  belongs_to :user

  validates :name, :website, presence: true
end