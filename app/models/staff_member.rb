class StaffMember < ActiveRecord::Base
  class GroupMemberError < StandardError; end

  has_one :identity, :as => :identifiable, :dependent => :destroy
  has_many :notifications, :as => :remindable, :dependent => :destroy
  belongs_to :device
  belongs_to :restaurant
  belongs_to :staff_kind
  belongs_to :group
  has_many :access_tokens, :class_name => 'Doorkeeper::AccessToken', :as => :owner, :dependent => :destroy
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
    return owns_device object if object.class == Device
    return owns_credit_card object if object.class == CreditCard
    false
  end

  def new_staff_kind=(staff_kind)
    raise GroupMemberError if self.group_id
    self.staff_kind = staff_kind
  end

  def type
    'StaffMember'
  end

  def max_orders
    15
  end

  def online?
    self.last_seen > Time.now-(60*15)
  end

  def scopes
    staff_kind ? staff_kind.scopes : []
  end

  Order::State::STATES.each_with_index do |state, index|
    eval(
        <<-eos
    def #{state}_orders
      result = []
      if self.group
        self.group.staff_members do |staff_member|
          result.concat(Order.where("state_cd = #{index} AND staff_member_id = " + staff_member.id.to_s))
        end
      else
        result.concat(Order.where("state_cd = #{index} AND staff_member_id = " + self.id.to_s))
      end
      result
    end
    eos
    )
  end

  OrderItem::State::STATES.each_with_index do |state, index|
    eval(
        <<-eos
    def #{state}_order_items
      result = []
      if self.group
        self.group.staff_members do |staff_member|
          result.concat(OrderItem.where("state_cd = #{index} AND staff_member_id = " + staff_member.id.to_s))
        end
      else
        result.concat(OrderItem.where("state_cd = #{index} AND staff_member_id = " + self.id.to_s))
      end
      result
    end
    eos
    )
  end

  def can_order?
    current_orders.size < max_orders
  end

  def has_current_orders?
    current_orders.size > 0
  end

  def current_orders
    Order.where("state_cd != 4 AND state_cd != 5 AND staff_member_id = #{self.id}")
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
    OrderItem.where(:staff_member_id => self.id, :id => order_item.id).size > 0
  end

  def owns_notification(notification)
    notification.remindable_id == self.id
  end

  def owns_device(device)
    self.device_id == device.id
  end

  def owns_credit_card(credit_card)
    false
  end

  class << self
    def online(restaurant_id)
      StaffMember.where(:last_seen => Time.now-(60*15)..Time.now, :restaurant_id => restaurant_id)
    end
  end
end