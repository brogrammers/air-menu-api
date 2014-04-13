class Order
  class OpenState

    def initialize(order)
      @order = order
    end

    def cancelled!
      @order.state = :cancelled
      @order.cancelled_time = Time.now.iso8601
      @order.save!
    end

    def approved!
      @order.state = :approved
      @order.approved_time = Time.now.iso8601
      @order.save!
    end

    def paid!
      raise StateError
    end

    def served!
      raise StateError
    end

    def open!
      raise StateError
    end

  end
end