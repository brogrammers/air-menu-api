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
    self.menu_item.menu_section.staff_kind.staff_members.each do |staff_member|
      if staff_member.staff_kind.accept_order_items
        staff_member.order_items << self
        return
      end
    end
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