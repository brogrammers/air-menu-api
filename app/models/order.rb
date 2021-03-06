require Rails.root + 'lib/air_menu'

class Order < ActiveRecord::Base
  include State

  belongs_to :user
  belongs_to :restaurant
  belongs_to :staff_member
  has_many :order_items, :dependent => :destroy

  after_initialize :set_state

  def set_state
    unless self.state.nil?
      current_state = "Order::#{self.state.to_s.camelcase}State".constantize
      @state_delegate = current_state.new self
    end
  end

  def assign!
    candidates = possible_staff_members
    candidates.first.orders << self unless candidates.empty?
  end

  def possible_staff_members
    possible_staff_members = []
    self.restaurant.staff_members.each do |staff_member|
      possible_staff_members << staff_member if staff_member.staff_kind && staff_member.staff_kind.accept_orders
    end
    possible_staff_members.sort! { |staff_member, next_staff_member| staff_member.current_orders.size <=> next_staff_member.current_orders.size }
    possible_staff_members
  end

  def declined!
    reset!
    AirMenu::NotificationDispatcher.new(self.user, :declined_order_user).dispatch
  end

  def cancelled!
    @state_delegate.cancelled!
    AirMenu::NotificationDispatcher.new(self.user, :cancelled_order_user).dispatch
  end

  def approved!
    @state_delegate.approved!
    AirMenu::NotificationDispatcher.new(self.user, :approved_order_user).dispatch
    AirMenu::NotificationDispatcher.new(self.staff_member, :approved_order_staff_member).dispatch
  end

  def served!
    @state_delegate.served!
    AirMenu::NotificationDispatcher.new(self.user, :served_order_user).dispatch
  end

  def paid!
    @state_delegate.paid!
    AirMenu::NotificationDispatcher.new(self.user, :successful_payment_user).dispatch
    AirMenu::NotificationDispatcher.new(self.staff_member, :successful_payment_staff_member).dispatch
  end

  def open!
    @state_delegate.open!
    distribute_order
  end

  def reset!
    self.staff_member = nil
    self.state_cd = 0
    save!
    self.order_items.each do |order_item|
      order_item.reset!
    end
  end

  def distribute_order
    assign! unless self.staff_member
    self.order_items.each do |order_item|
      order_item.assign!
    end
  end
end