class Owner < ActiveRecord::Base
  has_one :identity, as: :identifiable

  validates :name, presence: true
end