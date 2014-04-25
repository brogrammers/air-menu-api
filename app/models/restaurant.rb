class Restaurant < ActiveRecord::Base
  has_many :menus
  has_many :orders
  has_many :staff_kinds
  has_many :staff_members
  has_many :groups
  has_many :reviews
  has_many :devices, :as => :notifiable
  has_one :address, :as => :contactable
  has_one :location, :as => :findable
  belongs_to :company

  def current_orders
    Order.where(:served_time => nil, :restaurant_id => self.id)
  end

  def active_menu
    @active_menu ||= Menu.find(self.active_menu_id) rescue nil
  end
end