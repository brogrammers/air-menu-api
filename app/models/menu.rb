class Menu < ActiveRecord::Base
  belongs_to :restaurant
  has_many :menu_sections, :dependent => :destroy

  def active?
    self.restaurant.active_menu_id == self.id
  end
end