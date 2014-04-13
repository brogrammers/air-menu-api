class Order
  class StateError < StandardError; end
  module State
    STATES = [:new, :open, :approved, :served, :paid, :cancelled]

    STATES.each_with_index do |state, index|
      eval("#{state.to_s.upcase} = #{index}")
    end

    def self.state_number(state)
      STATES.index state
    end

    def self.state(state_number)
      state_number.nil? ? nil : STATES[state_number]
    end

    def state=(state)
      self.state_cd = State.state_number state
    end

    def state
      State.state(self.state_cd)
    end

    STATES.each do |state|
      eval(
          <<-eos
  def #{state}?
    self.state == :#{state}
  end
      eos
      )
    end

    OrderItem::State::STATES.each do |state|
      eval(
          <<-eos
  def order_items_#{state}?
    #{state} = true
    self.order_items.each do |order_item|
      #{state} = order_item.#{state}?
    end
    #{state}
  end

  def order_items_not_#{state}?
    self.order_items.each do |order_item|
      return false if order_item.#{state}?
    end
  end

  def order_items_at_least_one_#{state}?
    self.order_items.each do |order_item|
      return true if order_item.#{state}?
    end
  end
      eos
      )
    end

    def check_approved
      if order_items_not_new?
        if order_items_approved?
          self.approved!
        else
          self.declined!
        end
      end
    end

    def check_served
      if order_items_not_new? and order_items_served?
        self.served!
      end
    end
  end
end