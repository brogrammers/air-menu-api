class StaffKind < ActiveRecord::Base
  has_many :staff_kind_scopes
  has_many :scopes, :through => :staff_kind_scopes
  has_many :menu_items
  has_many :menu_sections
  belongs_to :restaurant

  before_destroy :reassign_menu_items
  before_destroy :reassign_menu_sections

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

  private

  def reassign_menu_items
    self.menu_items.each do |menu_item|
      menu_item.staff_kind = nil
      menu_item.save!
    end
  end

  def reassign_menu_sections
    self.menu_sections do |menu_section|
      menu_section.staff_kind = nil
      menu_section.save!
    end
  end
end