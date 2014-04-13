require Rails.root + 'lib/air_menu'

class Order < ActiveRecord::Base
  include State

  belongs_to :user
  belongs_to :restaurant
  belongs_to :staff_member
  has_many :order_items

  after_initialize :set_state

  def set_state
    unless self.state.nil?
      current_state = "Order::#{self.state.to_s.camelcase}State".constantize
      @state_delegate = current_state.new self
    end
  end

  def assign!
    self.restaurant.staff_members.each do |staff_member|
      if staff_member.staff_kind.accept_orders
        staff_member.orders << self
        return
      end
    end
  end

  def declined!
    AirMenu::NotificationDispatcher.new(self.user, :declined_order).dispatch
  end

  def cancelled!
    @state_delegate.cancelled!
    AirMenu::NotificationDispatcher.new(self.user, :cancelled_time).dispatch
  end

  def approved!
    @state_delegate.approved!
    AirMenu::NotificationDispatcher.new(self.user, :approved_order).dispatch
  end

  def served!
    @state_delegate.served!
    AirMenu::NotificationDispatcher.new(self.user, :served_order).dispatch
  end

  def paid!
    @state_delegate.paid!
    AirMenu::NotificationDispatcher.new(self.user, :successful_payment).dispatch
  end

  def open!
    @state_delegate.open!
    distribute_order
    AirMenu::NotificationDispatcher.new(self.staff_member, :new_order).dispatch
  end

  def distribute_order
    assign!
    self.order_items.each do |order_item|
      order_item.assign!
    end
  end
end