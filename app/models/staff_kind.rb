class StaffKind < ActiveRecord::Base
  has_and_belongs_to_many :scopes
  belongs_to :restaurant

  def staff_members
    StaffMember.where(:staff_kind_id => self.id)
  end
end