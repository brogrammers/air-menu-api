#encoding: utf-8

module AirMenu
  class DatabaseData
    STAFF_KIND = [
        {
            :name => 'Manager',
            :restaurant_id => 1,
            :accept_orders => false,
            :accept_order_items => false
        },
        {
            :name => 'Waiters',
            :restaurant_id => 1,
            :accept_orders => true,
            :accept_order_items => false
        },
        {
            :name => 'Kitchen Staff',
            :restaurant_id => 1,
            :accept_orders => false,
            :accept_order_items => true
        },
        {
            :name => 'Bar Staff',
            :restaurant_id => 1,
            :accept_orders => false,
            :accept_order_items => true
        },
        {
            :name => 'Manager',
            :restaurant_id => 2,
            :accept_orders => true,
            :accept_order_items => false
        },
        {
            :name => 'Waitress',
            :restaurant_id => 2,
            :accept_orders => true,
            :accept_order_items => false
        },
        {
            :name => 'Kitchen',
            :restaurant_id => 2,
            :accept_orders => false,
            :accept_order_items => true
        }
    ]
  end
end