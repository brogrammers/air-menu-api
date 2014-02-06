class Company < ActiveRecord::Base
  has_one :address, :as => :contactable

  validates :name, :website, :user_id, presence: true
end