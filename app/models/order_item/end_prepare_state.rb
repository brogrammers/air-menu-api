class OrderItem
  class EndPrepareState

    def initialize(order_item)
      @order_item = order_item
      @order = order_item.order
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
      @order_item.state = :served
      @order_item.served_time = Time.now.iso8601
      @order_item.save!
    end

  end
end