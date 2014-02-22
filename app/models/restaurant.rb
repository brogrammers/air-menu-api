class Restaurant < ActiveRecord::Base
  has_many :menus
  has_many :orders
  has_one :address, :as => :contactable
  has_one :location, :as => :findable
  belongs_to :company

  def current_orders
    Order.where(:end_served => nil, :restaurant_id => self.id)
  end
end