class Menu < ActiveRecord::Base
  belongs_to :restaurant
  has_many :menu_sections

  def active?
    self.restaurant.active_menu_id == self.id
  end
end