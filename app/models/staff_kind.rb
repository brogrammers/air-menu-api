class StaffKind < ActiveRecord::Base
  has_many :staff_kind_scopes
  has_many :scopes, :through => :staff_kind_scopes
  belongs_to :restaurant

  def staff_members
    StaffMember.where(:staff_kind_id => self.id, :restaurant_id => self.restaurant.id)
  end

  def empty_scopes
    StaffKindScope.where(:staff_kind_id => self.id).each do |scope|
      scope.destroy
    end
  end

  def scope_array
    self.scopes.to_a.inject [] do |result, scope|
      result << scope.name
    end
  end
end