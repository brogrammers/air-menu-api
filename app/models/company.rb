class Company < ActiveRecord::Base
  has_one :address, :as => :contactable, :dependent => :destroy
  has_many :restaurants, :dependent => :destroy
  belongs_to :user

  validates :name, :website, presence: true
end