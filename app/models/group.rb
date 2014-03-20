class Group < ActiveRecord::Base
  has_many :staff_members
  belongs_to :restaurant
end