class OrderItem
  class DeclinedState

    def initialize(order_item)
      @order = order_item
    end

    def approved!
      raise StateError
    end

    def declined!
      raise StateError
    end

    def start_prepare!
      raise StateError
    end

    def end_prepare!
      raise StateError
    end

    def served!
      raise StateError
    end

  end
end