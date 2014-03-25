class OrderItem
  class NewState

    def initialize(order_item)
      @order_item = order_item
      @order = order_item.order
    end

    def approved!
      @order_item.state = :approved
      @order_item.approved_time = Time.now.iso8601
      @order_item.save!
    end

    def declined!
      @order_item.state = :declined
      @order_item.declined_time = Time.now.iso8601
      @order_item.save!
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