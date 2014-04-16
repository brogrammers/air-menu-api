class StaffKindScope < ActiveRecord::Base
  belongs_to :staff_kind
  belongs_to :scope
end