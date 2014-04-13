class StaffMember < ActiveRecord::Base
  has_one :identity, :as => :identifiable
  has_many :notifications, :as => :remindable
  has_many :devices, :as => :notifiable
  belongs_to :restaurant
  belongs_to :staff_kind
  belongs_to :group
  has_many :access_tokens, :class_name => 'Doorkeeper::AccessToken', :as => :owner
  has_many :orders
  has_many :order_items

  def owns(object)
    return owns_restaurant object if object.class == Restaurant
    return owns_menu object if object.class == Menu
    return owns_menu_section object if object.class == MenuSection
    return owns_menu_item object if object.class == MenuItem
    return owns_order object if object.class == Order
    return owns_order_item object if object.class == OrderItem
    return owns_notification object if object.class == Notification
    false
  end

  def type
    'StaffMember'
  end

  def max_orders
    15
  end

  def current_orders
    Order.where("state_cd != 4 AND staff_member_id = #{self.id}")
  end

  def can_order?
    current_orders.size < max_orders
  end

  def has_current_orders?
    current_orders.size > 0
  end

  def unread
    Notification.where(:remindable_id => self.id, :read => false)
  end

  def unread_count
    unread.count
  end

  def company
    nil
  end

  private

  def owns_restaurant(restaurant)
    self.restaurant.id == restaurant.id
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
    self.restaurant.orders.each do |restaurant_order|
      return true if restaurant_order.id == order.id
    end
    false
  end

  def owns_order_item(order_item)
    owns_order order_item.order
  end

  def owns_notification(notification)
    notification.remindable_id == self.id
  end

end