class Order
  class CancelledState

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
      raise StateError
    end

    def open!
      raise StateError
    end

  end
end