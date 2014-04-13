class Order
  class NewState

    def initialize(order)
      @order = order
    end

    def cancelled!
      @order.state = :cancelled
      @order.cancelled_time = Time.now.iso8601
      @order.save!
    end

    def approved!
      raise StateError
    end

    def paid!
      raise StateError
    end

    def served!
      raise StateError
    end

    def open!
      @order.state = :open
      @order.save!
    end

  end
end