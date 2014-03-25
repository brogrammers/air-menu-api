class Order < ActiveRecord::Base
  include State

  belongs_to :user
  belongs_to :restaurant
  has_many :order_items

  after_initialize :set_state

  def set_state
    unless self.state.nil?
      current_state = "Order::#{self.state.to_s.camelcase}State".constantize
      @state_delegate = current_state.new self
    end
  end

  def declined!
    # TODO: Notify user! Should stay in open state
  end

  def cancelled!
    @state_delegate.cancelled!
  end

  def approved!
    @state_delegate.approved!
    # TODO: Notify user
  end

  def served!
    @state_delegate.served!
    # TODO: Notify user
  end

  def paid!
    @state_delegate.paid!
    # TODO: Notify staff member
  end

  def open!
    @state_delegate.open!
    # TODO: Notify staff member
  end
end