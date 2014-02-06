class StaffMember < ActiveRecord::Base
  has_one :identity, :as => :identifiable
  belongs_to :restaurant
end