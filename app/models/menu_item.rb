class MenuItem < ActiveRecord::Base
  belongs_to :menu_section
  belongs_to :staff_kind

  def active?
    self.menu_section.active?
  end
end