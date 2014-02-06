class Address < ActiveRecord::Base
  belongs_to :contactable, polymorphic: true

  validates :address_1, :city, :county, :country, presence: true
end