class Restaurant < ActiveRecord::Base
  has_one :address, :as => :contactable
  has_one :location, :as => :findable
  belongs_to :company
end