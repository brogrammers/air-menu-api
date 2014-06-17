class MenuSection < ActiveRecord::Base
  has_many :menu_items, :dependent => :destroy
  belongs_to :menu
  belongs_to :staff_kind

  def active?
    self.menu.active?
  end
end