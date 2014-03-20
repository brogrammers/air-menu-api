class StaffMember < ActiveRecord::Base
  has_one :identity, :as => :identifiable
  belongs_to :restaurant
  belongs_to :staff_kind
  belongs_to :group
end