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
    candidates = possible_staff_members
    candidates.first.order_items << self unless candidates.empty?
    AirMenu::NotificationDispatcher.new(self.staff_member, :new_order_item_staff_member).dispatch
  end

  def possible_staff_members
    possible_staff_members = []
    self.order.restaurant.staff_members.each do |staff_member|
      possible_staff_members << staff_member if staff_member.staff_kind && staff_member.staff_kind.accept_order_items && accepted_staff_kind?(staff_member.staff_kind)
    end
    possible_staff_members.sort! { |staff_member, next_staff_member| staff_member.current_order_items.size <=> next_staff_member.current_order_items.size }
    possible_staff_members
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
    self.order.staff_member.order_items << self
    AirMenu::NotificationDispatcher.new(self.order.staff_member, :order_item_prepared_staff_member).dispatch
  end

  def served!
    @state_delegate.served!
    self.order.check_served
  end

  def reset!
    self.state_cd = 0
    self.staff_member = nil
    save!
  end

  def accepted_staff_kind?(staff_kind)
    accepted_staff_kind = self.menu_item.staff_kind || self.menu_item.menu_section.staff_kind
    return true if accepted_staff_kind.nil?
    staff_kind && staff_kind.id == accepted_staff_kind.id
  end
end