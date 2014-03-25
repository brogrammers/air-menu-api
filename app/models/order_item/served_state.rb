class OrderItem
  class ServedState

    def initialize(order_item)
      @order_item = order_item
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