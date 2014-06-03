class Menu < ActiveRecord::Base
  belongs_to :restaurant
  has_many :menu_sections, :dependent => :destroy

  before_destroy :reassign_active_menu_id

  def active?
    self.restaurant.active_menu_id == self.id
  end

  def reassign_active_menu_id
    if self.restaurant.active_menu_id == self.id
      restaurant.active_menu_id = nil
      restaurant.save!
    end
  end
end