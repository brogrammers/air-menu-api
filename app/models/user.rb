class User < ActiveRecord::Base
	has_one :identity, :as => :identifiable
  has_one :location, :as => :findable
  has_many :devices, :as => :notifiable
  has_one :company
  has_many :orders
  has_many :applications, :class_name => 'Doorkeeper::Application', :as => :owner
  has_many :access_tokens, :class_name => 'Doorkeeper::AccessToken', :as => :owner

	validates :name, presence: true

  def owns(object)
    return owns_company object if object.class == Company
    return owns_restaurant object if object.class == Restaurant
    return owns_menu object if object.class == Menu
    return owns_menu_section object if object.class == MenuSection
    return owns_menu_item object if object.class == MenuItem
    return owns_order object if object.class == Order
    return owns_order_item object if object.class == OrderItem
    false
  end

  def type
    self.company ? 'Owner' : 'User'
  end

  def max_orders
    1
  end

  def current_orders
    Order.where(:served_time => nil, :user_id => self.id)
  end

  def can_order?
    current_orders.size < max_orders
  end

  def has_current_orders?
    current_orders.size > 0
  end

  private

  def owns_company(company)
    return false unless self.company
    self.company.id == company.id
  end

  def owns_restaurant(restaurant)
    return false unless self.company
    self.company.restaurants.each do |owned_restaurant|
      return true if owned_restaurant.id == restaurant.id
    end
    false
  end

  def owns_menu(menu)
    owns_restaurant menu.restaurant
  end

  def owns_menu_section(menu_section)
    owns_menu menu_section.menu
  end

  def owns_menu_item(menu_item)
    owns_menu_section menu_item.menu_section
  end

  def owns_order(order)
    self.orders.each do |owned_order|
      return true if owned_order.id == order.id
    end
    self.company.restaurants.each do |owned_restaurant|
      return true if owned_restaurant.id == order.restaurant.id
    end if self.company
    false
  end

  def owns_order_item(order_item)
    owns_order order_item.order
  end
end