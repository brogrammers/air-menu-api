class Order
  class ServedState

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
      @order.state = :paid
      @order.save!
    end

    def served!
      raise StateError
    end

    def open!
      raise StateError
    end

  end
end