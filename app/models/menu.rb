class Menu < ActiveRecord::Base
  belongs_to :restaurant
  has_many :menu_sections
end