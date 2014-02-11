class Restaurant < ActiveRecord::Base
  has_many :menus
  has_one :address, :as => :contactable
  has_one :location, :as => :findable
  belongs_to :company
end