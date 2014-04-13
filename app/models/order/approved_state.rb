class Order
  class ApprovedState

    def initialize(order)
      @order = order
    end

    def cancelled!
      raise StateError
    end

    def approved!
      raise StateError
    end

    def paid!
      raise StateError
    end

    def served!
      @order.state = :served
      @order.served_time = Time.now.iso8601
      @order.save!
    end

    def open!
      raise StateError
    end

  end
end