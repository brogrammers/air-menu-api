class OrderItem < ActiveRecord::Base
  include State

  belongs_to :order
  belongs_to :menu_item
  belongs_to :staff_member

  after_initialize :set_state

  def set_state
    unless self.state.nil?
      current_state = "OrderItem::#{self.state.to_s.camelcase}State".constantize
      @state_delegate = current_state.new self
    end
  end

  def assign!
    possible_staff_members = []
    self.order.restaurant.online_staff_members.each do |staff_member|
      if staff_member.staff_kind && staff_member.staff_kind.accept_order_items
        possible_staff_members << staff_member
      end
    end
    possible_staff_members.sort! { |staff_member, next_staff_member| staff_member.current_orders.size <=> next_staff_member.current_orders.size }
    possible_staff_members.first.orders << self unless possible_staff_members.empty?
  end

  def approved!
    @state_delegate.approved!
    self.order.check_approved
  end

  def declined!
    @state_delegate.declined!
    self.order.check_approved
  end

  def start_prepare!
    @state_delegate.start_prepare!
  end

  def end_prepare!
    @state_delegate.end_prepare!
    AirMenu::NotificationDispatcher.new(self.staff_member, :order_item_prepared).dispatch
  end

  def served!
    @state_delegate.served!
    self.order.check_served
  end
end