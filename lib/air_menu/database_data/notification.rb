#encoding: utf-8

module AirMenu
  class DatabaseData
    NOTIFICATION = [
        {
            :content => 'Order has been approved',
            :read => true,
            :remindable_id => 1,
            :remindable_type => 'User',
            :payload => {
                :order_id => 1
            }.to_json
        }
    ]
  end
end