#encoding: utf-8
require 'json'
require 'pp'

def fill_database
  DATABASE_TABLES.each do |key, value|
    create_model key.to_s, value
  end
  puts "#{DATABASE_TABLES.size} tables populated"
  puts 'Finished inserting data'
end

def create_model(model, data)
  puts '============================'
  puts "  MODEL: #{proper_class_name model}"
  data.each_with_index do |serialized_object, index|
    puts '  ============================'
    puts "    INDEX: #{index}"
    object = get_instance model, index+1
    serialized_object.each do |key, value|
      eval("object.#{key} = value")
    end
    object.save!
    pp serialized_object
  end
end

MAPPER = {
    'Application' => 'Doorkeeper::Application'
}

def get_instance(name, index)
  constant = proper_class_name(name).constantize
  instance = constant.find index
  puts '    ============================'
  puts '      OLD INSTANCE'
  instance
rescue ActiveRecord::RecordNotFound
  puts '    ============================'
  puts '      NEW INSTANCE'
  constant.new
end

def proper_class_name(name)
  converted_name = convert_to_constant_string name
  MAPPER[converted_name] ? MAPPER[converted_name] : converted_name
end

def convert_to_constant_string(name)
  parts = name.split '_'
  parts.each_with_index { |part, index| parts[index] = part.camelize }
  parts.join ''
end



DATABASE_TABLES = {
  :application => [
      {
          :name => 'iOS Restaurant',
          :redirect_uri => 'http://localhost/',
          :trusted => true
      },
      {
          :name => 'iOS Customer',
          :redirect_uri => 'http://localhost/',
          :trusted => true
      }
  ],

  :user => [
      {
          :name => 'Max Hoffmann',
          :phone => '+353832343234'
      },
      {
          :name => 'Robert Lis',
          :phone => '+353833754543'
      },
      {
          :name => 'Gary Plum',
          :phone => '+353876485875'
      },
      {
          :name => 'Martin Scum',
          :phone => '+353863423875'
      },
      {
          :name => 'Denis McKenna',
          :phone => '+35385435645'
      }
  ],

  :credit_card => [
      {
          :number => '4319445320747508',
          :card_type => 'VISA',
          :month => '01',
          :year => '17',
          :cvc => '445',
          :user_id => 1
      },
      {
          :number => '5432672370544532',
          :card_type => 'MASTERCARD',
          :month => '01',
          :year => '17',
          :cvc => '445',
          :user_id => 1
      },
      {
          :number => '4319445320747508',
          :card_type => 'VISA',
          :month => '01',
          :year => '17',
          :cvc => '445',
          :user_id => 2
      },
      {
          :number => '5432672370544532',
          :card_type => 'MASTERCARD',
          :month => '01',
          :year => '17',
          :cvc => '445',
          :user_id => 2
      },
      {
          :number => '4319445320747508',
          :card_type => 'VISA',
          :month => '01',
          :year => '17',
          :cvc => '445',
          :user_id => 3
      },
      {
          :number => '5432672370544532',
          :card_type => 'MASTERCARD',
          :month => '01',
          :year => '17',
          :cvc => '445',
          :user_id => 3
      }
  ],

  :identity => [
      {
          :username => 'tsov',
          :new_password => 'davinci',
          :email => 'tsov@me.com',
          :admin => true,
          :developer => true,
          :identifiable_id => 1,
          :identifiable_type => 'User'
      },
      {
          :username => 'rob',
          :new_password => 'password123',
          :email => 'robertmadman@gmail.com',
          :admin => true,
          :developer => true,
          :identifiable_id => 2,
          :identifiable_type => 'User'
      },
      {
          :username => 'gary',
          :new_password => 'davinci',
          :email => 'gary@thechurch.ie',
          :admin => false,
          :developer => false,
          :identifiable_id => 3,
          :identifiable_type => 'User'
      },
      {
          :username => 'fritz',
          :new_password => 'davinci',
          :email => 'fritz@thechurch.ie',
          :identifiable_id => 1,
          :identifiable_type => 'StaffMember'
      },
      {
          :username => 'martin',
          :new_password => 'davinci',
          :email => 'martin@scum.ie',
          :identifiable_id => 4,
          :identifiable_type => 'User'
      },
      {
          :username => 'denis',
          :new_password => 'davinci',
          :email => 'denis@mckenna.ie',
          :identifiable_id => 5,
          :identifiable_type => 'User'
      },
      {
          :username => 'emma',
          :new_password => 'davinci',
          :email => 'emma@mckenna.ie',
          :identifiable_id => 2,
          :identifiable_type => 'StaffMember'
      },
      {
          :username => 'patrick',
          :new_password => 'davinci',
          :email => 'patrick@mckenna.ie',
          :identifiable_id => 3,
          :identifiable_type => 'StaffMember'
      },
      {
          :username => 'hugo',
          :new_password => 'davinci',
          :email => 'hugo@mckenna.ie',
          :identifiable_id => 4,
          :identifiable_type => 'StaffMember'
      },
      {
          :username => 'ted',
          :new_password => 'davinci',
          :email => 'ted@mckenna.ie',
          :identifiable_id => 5,
          :identifiable_type => 'StaffMember'
      },
      {
          :username => 'sarah',
          :new_password => 'davinci',
          :email => 'sarah@mckenna.ie',
          :identifiable_id => 6,
          :identifiable_type => 'StaffMember'
      }
  ],

  :company => [
      {
          :name => 'Brogrammers',
          :website => 'http://brogrammers.info',
          :user_id => 1
      },
      {
          :name => 'The Church',
          :website => 'http://thechurch.ie',
          :user_id => 3
      },
      {
          :name => 'Nandos',
          :website => 'http://nandos.co.uk',
          :user_id => 4
      },
      {
          :name => 'Robs & Co',
          :website => 'http://robsandco.com',
          :user_id => 2
      }
  ],

  :address => [
      {
          :address_1 => 'SomeOffice House 45',
          :address_2 => 'Business Campus',
          :city => 'Dublin',
          :county => 'Dublin',
          :country => 'Ireland',
          :contactable_id => 1,
          :contactable_type => 'Company'
      },
      {
          :address_1 => 'Junction of Mary St',
          :address_2 => 'Jervis St',
          :city => 'Dublin',
          :county => 'Dublin',
          :country => 'Ireland',
          :contactable_id => 2,
          :contactable_type => 'Company'
      },
      {
          :address_1 => 'Junction of Mary St',
          :address_2 => 'Jervis St',
          :city => 'Dublin',
          :county => 'Dublin',
          :country => 'Ireland',
          :contactable_id => 1,
          :contactable_type => 'Restaurant'
      },
      {
          :address_1 => 'Junction of Mary St',
          :address_2 => 'Jervis St',
          :city => 'Dublin',
          :county => 'Dublin',
          :country => 'Ireland',
          :contactable_id => 3,
          :contactable_type => 'Company'
      }
  ],

  :restaurant => [
      {
          :name => 'The Church',
          :description => 'St. Mary’s closed in 1964 and lay derelict for a number of years until it was purchased by John Keating in 1997. Following extensive restoration over a seven year period, this List 1 building finally re-opened its doors in December 2005 as John M. Keating’s Bar. The tasteful conversion and refurbishment of this Dublin landmark was acknowledged at the Dublin City Neighbourhood Awards 2006, where it won first prize in the category of Best Old Building In September 2007 the building was acquired by new owners and renamed "The Church Bar & Restaurant" and its range of services was expanded to include a Cafe, Night Club and a Barbeque area on the terrace.',
          :loyalty => false,
          :remote_order => false,
          :conversion_rate => 0.0,
          :company_id => 2,
          :active_menu_id => 3
      },
      {
          :name => 'Nandos',
          :loyalty => false,
          :remote_order => false,
          :conversion_rate => 0.0,
          :company_id => 3,
          :active_menu_id => nil
      },
      {
          :name => 'Robs',
          :loyalty => false,
          :remote_order => false,
          :conversion_rate => 0.0,
          :company_id => 4,
          :active_menu_id => 4
      }
  ],

  :staff_member => [
      {
          :name => 'Fritz Blah',
          :staff_kind_id => 1,
          :restaurant_id => 1,
          :device_id => 1
      },
      {
          :name => 'Emma Blah',
          :staff_kind_id => 2,
          :restaurant_id => 1,
          :device_id => 2,
          :group_id => 1
      },
      {
          :name => 'Patrick Blah',
          :staff_kind_id => 3,
          :restaurant_id => 1
      },
      {
          :name => 'Hugo Blah',
          :staff_kind_id => 4,
          :restaurant_id => 1
      },
      {
          :name => 'Ted Blah',
          :staff_kind_id => 5,
          :restaurant_id => 2
      },
      {
          :name => 'Sarah Blah',
          :staff_kind_id => 6,
          :restaurant_id => 2
      }
  ],

  :staff_kind => [
      {
          :name => 'Manager',
          :restaurant_id => 1,
          :accept_orders => true,
          :accept_order_items => false
      },
      {
          :name => 'Waitress',
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
          :accept_order_items => true
      },
      {
          :name => 'Kitchen',
          :restaurant_id => 2,
          :accept_orders => false,
          :accept_order_items => true
      }
  ],

  :group => [
      {
          :name => 'Waiters',
          :restaurant_id => 1,
          :device_id => 3
      }
  ],

  :menu => [
      {
          :name => 'Main Menu',
          :restaurant_id => 1
      },
      {
          :name => 'Alternative Menu',
          :restaurant_id => 1
      },
      {
          :name => 'Main Menu',
          :restaurant_id => 1
      },
      {
          :name => 'Main Menu',
          :restaurant_id => 3
      }
  ],

  :menu_section => [
      {
          :name => 'Main Foods',
          :description => 'All our main dishes',
          :menu_id => 1,
          :staff_kind_id => 2
      },
      {
          :name => 'Alcoholic Drinks',
          :description => 'Our list of Wines, Beers & Spirits',
          :menu_id => 1,
          :staff_kind_id => 3
      },
      {
          :name => 'Some Menu Section',
          :description => 'blah',
          :menu_id => 2
      },
      {
          :name => 'Peri Peri Chicken',
          :description => 'Our signature dish. Chicken marinated for at least 24 hours in PERi-PERi sauce and flame-grilled to order. PERi-PERi chicken for purists.',
          :menu_id => 3
      },
      {
          :name => 'Platter to share',
          :description => '',
          :menu_id => 3
      }
  ],

  :menu_item => [
      {
          :name => 'Beef Burger',
          :description => 'Beef Burger with a small side salad.',
          :price => 12.90,
          :currency => 'EUR',
          :menu_section_id => 1,
          :staff_kind_id => 3
      },
      {
          :name => 'Corona',
          :description => '0.5',
          :price => 5.70,
          :currency => 'EUR',
          :menu_section_id => 2,
          :staff_kind_id => 3
      },
      {
          :name => 'Corona Light',
          :description => '0.5',
          :price => 5.70,
          :currency => 'EUR',
          :menu_section_id => 2
      },
      {
          :name => 'Blue',
          :description => '0.5',
          :price => 5.70,
          :currency => 'EUR',
          :menu_section_id => 2
      },
      {
          :name => 'Tiger',
          :description => '0.5',
          :price => 5.70,
          :currency => 'EUR',
          :menu_section_id => 2
      },
      {
          :name => 'Bam',
          :description => '0.5',
          :price => 5.60,
          :currency => 'EUR',
          :menu_section_id => 2
      },
      {
          :name => 'Bam',
          :description => '0.5',
          :price => 5.60,
          :currency => 'EUR',
          :menu_section_id => 3
      },
      {
          :name => 'Chicken Butterfly',
          :description => 'Succulent chicken breasts in crispy skin. No bones about it - pure class!',
          :price => 10.25,
          :currency => 'EUR',
          :menu_section_id => 4
      },
      {
          :name => '1/4 Chicken Breast',
          :description => '',
          :price => 7.20,
          :currency => 'EUR',
          :menu_section_id => 4
      },
      {
          :name => '1/4 Chicken Leg',
          :description => '',
          :price => 7.20,
          :currency => 'EUR',
          :menu_section_id => 4
      },
      {
          :name => '1/2 Chicken',
          :description => '',
          :price => 9.95,
          :currency => 'EUR',
          :menu_section_id => 4
      },
      {
          :name => '5 Chicken Wings',
          :description => '',
          :price => 8.40,
          :currency => 'EUR',
          :menu_section_id => 4
      },
      {
          :name => 'Wing Platter',
          :description => 'For 2-3 people to share. 10 Chicken Wings + 2 Large or 4 Reg Sides',
          :price => 16.80,
          :currency => 'EUR',
          :menu_section_id => 5
      },
      {
          :name => 'Full Platter',
          :description => 'For 2-3 people to share. Whole Chicken + 2 Large or 4 Reg Sides',
          :price => 19.85,
          :currency => 'EUR',
          :menu_section_id => 5
      },
      {
          :name => 'Meal Platter',
          :description => 'For 2 people to share. Whole Chicken + 1 Large or 2 Reg Sides + 2 Bottomless Soft Drinks',
          :price => 19.85,
          :currency => 'EUR',
          :menu_section_id => 5
      },
      {
          :name => 'Jumbo Platter',
          :description => 'For 4-6 people to share. 2 Whole Chickens + 5 Large Sides',
          :price => 43.50,
          :currency => 'EUR',
          :menu_section_id => 5
      }
  ],

  :order => [
      {
          :user_id => 5,
          :state_cd => 0,
          :restaurant_id => 1
      }
  ],

  :order_item => [
      {
          :order_id => 1,
          :menu_item_id => 10,
          :count => 1,
          :state_cd => 0
      }
  ],

  :device => [
      {
          :name => 'Waiter Phone',
          :uuid => 'iw47b8gr376wefbr8764grb78wg94n8r7ngesdfw',
          :token => 'ysidf85sad76f2oq3gr6we84732423892b34234',
          :platform => 'ios',
          :notifiable_id => 1,
          :notifiable_type => 'Restaurant'
      },
      {
          :name => 'Bar Phone',
          :uuid => 'jsdhfshdfkuhsdfkhsdkfgwye6234er23b7823942',
          :token => 'oudsft23r92362332yewgbywet6wet67w64brwr7',
          :platform => 'ios',
          :notifiable_id => 1,
          :notifiable_type => 'Restaurant'
      },
      {
          :name => 'Group Phone',
          :uuid => 'skdfgds56sdf5sdfsdf767as55as332342df4566a',
          :token => 'ygasd4as823hg8g3846g7gwe7rgw76er76wer721',
          :platform => 'ios',
          :notifiable_id => 1,
          :notifiable_type => 'Restaurant'
      }
  ],

  :staff_kind_scope => [
      {
          :staff_kind_id => 1,
          :scope_id => 1
      },
      {
          :staff_kind_id => 1,
          :scope_id => 2
      },
      {
          :staff_kind_id => 1,
          :scope_id => 3
      },
      {
          :staff_kind_id => 1,
          :scope_id => 4
      },
      {
          :staff_kind_id => 1,
          :scope_id => 5
      },
      {
          :staff_kind_id => 1,
          :scope_id => 6
      },
      {
          :staff_kind_id => 1,
          :scope_id => 7
      },
      {
          :staff_kind_id => 1,
          :scope_id => 8
      },
      {
          :staff_kind_id => 1,
          :scope_id => 9
      },
      {
          :staff_kind_id => 1,
          :scope_id => 10
      },
      {
          :staff_kind_id => 1,
          :scope_id => 11
      },
      {
          :staff_kind_id => 1,
          :scope_id => 12
      },
      {
          :staff_kind_id => 1,
          :scope_id => 13
      },
      {
          :staff_kind_id => 1,
          :scope_id => 14
      },
      {
          :staff_kind_id => 1,
          :scope_id => 15
      },
      {
          :staff_kind_id => 1,
          :scope_id => 16
      }
  ],

  :scope => [
      {
          :name => 'get_menus'
      },
      {
          :name => 'add_menus'
      },
      {
          :name => 'add_active_menus'
      },
      {
          :name => 'update_menus'
      },
      {
          :name => 'delete_menus'
      },
      {
          :name => 'get_orders'
      },
      {
          :name => 'add_orders'
      },
      {
          :name => 'update_orders'
      },
      {
          :name => 'get_groups'
      },
      {
          :name => 'add_orders'
      },
      {
          :name => 'update_orders'
      },
      {
          :name => 'get_groups'
      },
      {
          :name => 'create_groups'
      },
      {
          :name => 'delete_groups'
      },
      {
          :name => 'get_devices'
      },
      {
          :name => 'create_devices'
      },
      {
          :name => 'update_devices'
      },
      {
          :name => 'delete_devices'
      },
      {
          :name => 'get_staff_kinds'
      },
      {
          :name => 'create_staff_kinds'
      },
      {
          :name => 'update_staff_kinds'
      },
      {
          :name => 'delete_staff_kinds'
      },
      {
          :name => 'get_staff_members'
      },
      {
          :name => 'create_staff_members'
      },
      {
          :name => 'update_staff_members'
      },
      {
          :name => 'delete_staff_members'
      },
      {
          :name => 'create_payments'
      },
      {
          :name => 'get_opening_hours'
      },
      {
          :name => 'create_opening_hours'
      },
      {
          :name => 'update_opening_hours'
      },
      {
          :name => 'delete_opening_hours'
      },
      {
          :name => 'get_webhooks'
      },
      {
          :name => 'create_webhooks'
      },
      {
          :name => 'update_webhooks'
      },
      {
          :name => 'delete_webhooks'
      }
  ],

  :location => [
      {
          :latitude => 59.23454,
          :longitude => 59.23454,
          :findable_id => 1,
          :findable_type => 'Restaurant'
      }
  ],

  :review => [
      {
          :subject => 'Awesome',
          :message => 'The food is good, the service is fast and the location is perfect!',
          :rating => 4,
          :user_id => 1,
          :restaurant_id => 1
      }
  ],

  :notification => [
      {
          :content => 'Order has been approved',
          :read => true,
          :remindable_id => 1,
          :remindable_type => 'User',
          :payload => {
              :order_id => 1
          }.to_json
      }
  ],

  :webhook => [
      {
          :on_action => 'show',
          :on_method => 'api/v1/restaurants',
          :host => 'http://localhost:3001',
          :path => '/api/v1/me',
          :params => { 'key' => 'value' }.to_json,
          :headers => { 'Content-Type' => 'application/json' }.to_json,
          :restaurant_id => 1
      }
  ],

  :opening_hour => [
      {
          :day => 'monday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'tuesday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'wednesday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'thursday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'friday',
          :start => Time.iso8601('2000-01-01T10:00:00Z'),
          :end => Time.iso8601('2000-01-01T21:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'saturday',
          :start => Time.iso8601('2000-01-01T10:00:00Z'),
          :end => Time.iso8601('2000-01-01T22:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'sunday',
          :start => Time.iso8601('2000-01-01T11:00:00Z'),
          :end => Time.iso8601('2000-01-01T19:00:00Z'),
          :restaurant_id => 1
      },
      {
          :day => 'monday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 2
      },
      {
          :day => 'tuesday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 2
      },
      {
          :day => 'wednesday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 2
      },
      {
          :day => 'thursday',
          :start => Time.iso8601('2000-01-01T09:00:00Z'),
          :end => Time.iso8601('2000-01-01T20:00:00Z'),
          :restaurant_id => 2
      },
      {
          :day => 'friday',
          :start => Time.iso8601('2000-01-01T10:00:00Z'),
          :end => Time.iso8601('2000-01-01T21:00:00Z'),
          :restaurant_id => 2
      },
      {
          :day => 'saturday',
          :start => Time.iso8601('2000-01-01T10:00:00Z'),
          :end => Time.iso8601('2000-01-01T22:00:00Z'),
          :restaurant_id => 2
      },
      {
          :day => 'sunday',
          :start => Time.iso8601('2000-01-01T11:00:00Z'),
          :end => Time.iso8601('2000-01-01T19:00:00Z'),
          :restaurant_id => 2
      }
  ]
}