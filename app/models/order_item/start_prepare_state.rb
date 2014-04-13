class OrderItem
  class StartPrepareState

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
      @order_item.state = :end_prepare
      @order_item.end_prepare_time = Time.now.iso8601
      @order_item.save!
    end

    def served!
      raise StateError
    end

  end
end