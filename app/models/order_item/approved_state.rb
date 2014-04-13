class OrderItem
  class ApprovedState

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
      @order_item.state = :start_prepare
      @order_item.start_prepare_time = Time.now.iso8601
      @order_item.save!
    end

    def end_prepare!
      raise StateError
    end

    def served!
      raise StateError
    end

  end
end