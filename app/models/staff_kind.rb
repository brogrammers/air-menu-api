class StaffKind < ActiveRecord::Base
  has_and_belongs_to_many :scopes
  belongs_to :restaurant
end