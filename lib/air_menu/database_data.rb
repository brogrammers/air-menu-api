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
          :name => 'Max Hoffmann'
      },
      {
          :name => 'Robert Lis'
      },
      {
          :name => 'Gary Plum'
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
      }
  ],

  :restaurant => [
      {
          :name => 'The Church',
          :loyalty => false,
          :remote_order => false,
          :conversion_rate => 0.0,
          :company_id => 2,
          :active_menu_id => 1
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
      }
  ],

  :menu_section => [
      {
          :name => 'Main Foods',
          :description => 'All our main dishes',
          :menu_id => 1
      },
      {
          :name => 'Alcoholic Drinks',
          :description => 'Our list of Wines, Beers & Spirits',
          :menu_id => 1
      },
      {
          :name => 'Some Menu Section',
          :description => 'blah',
          :menu_id => 2
      }
  ],

  :menu_item => [
      {
          :name => 'Beef Burger',
          :description => 'Beef Burger with a small side salad.',
          :price => 12.90,
          :currency => 'EUR',
          :menu_section_id => 1
      },
      {
          :name => 'Corona',
          :description => '0.5',
          :price => 5.70,
          :currency => 'EUR',
          :menu_section_id => 2
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
      }
  ],

  :scope => [
      {
          :name => 'get_all_current_orders'
      },
      {
          :name => 'get_all_orders'
      },
      {
          :name => 'create_new_orders'
      },
      {
          :name => 'change_orders'
      },
      {
          :name => 'cancel_orders'
      }
  ]
}