class MenuItem < ActiveRecord::Base
  belongs_to :menu_section

  def active?
    self.menu_section.active?
  end
end