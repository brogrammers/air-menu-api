class User < ActiveRecord::Base
	has_one :identity, :as => :identifiable
  has_one :location, :as => :findable
  has_one :company

	validates :name, presence: true
end