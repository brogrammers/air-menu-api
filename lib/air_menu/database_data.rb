APPLICATIONS = [
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
]

USERS = [
    {
        :name => 'Max Hoffmann',
        :meta => {
            :identity => 0,
            :company => 0
        }
    },
    {
        :name => 'Robert Lis',
        :meta => {
            :identity => 1
        }
    },
    {
        :name => 'Gary Plum',
        :meta => {
            :identity => 2,
            :company => 1
        }
    }
]

IDENTITIES = [
    {
        :username => 'tsov',
        :password => 'davinci',
        :email => 'tsov@me.com',
        :admin => true,
        :developer => true
    },
    {
        :username => 'rob',
        :password => 'password123',
        :email => 'robertmadman@gmail.com',
        :admin => true,
        :developer => true
    },
    {
        :username => 'gary',
        :password => 'davinci',
        :email => 'gary@thechurch.ie',
        :admin => false,
        :developer => false
    }
]

COMPANIES = [
    {
        :name => 'Brogrammers',
        :website => 'http://brogrammers.info',
        :meta => {
            :user => 0,
            :address => 0
        }
    },
    {
        :name => 'The Church',
        :website => 'http://thechurch.ie',
        :meta => {
            :user => 2,
            :address => 1
        }
    }
]

ADDRESSES = [
    {
        :address_1 => 'SomeOffice House 45',
        :address_2 => 'Business Campus',
        :city => 'Dublin',
        :county => 'Dublin',
        :country => 'Ireland'
    },
    {
        :address_1 => 'Junction of Mary St',
        :address_2 => 'Jervis St',
        :city => 'Dublin',
        :county => 'Dublin',
        :country => 'Ireland'
    },
    {
        :address_1 => 'Junction of Mary St',
        :address_2 => 'Jervis St',
        :city => 'Dublin',
        :county => 'Dublin',
        :country => 'Ireland'
    }
]

RESTAURANTS = [
    {
        :name => 'The Church',
        :loyalty => false,
        :remote_order => false,
        :conversion_rate => 0.0,
        :meta => {
            :company => 1,
            :address => 2
        }
    }
]


def fill_scopes
  %w{get_all_current_orders get_all_orders create_new_orders cancel_order}.each do |name|
    scope = Scope.new
    scope.name = name
    scope.save!
  end
end

def fill_oauth_applications
  APPLICATIONS.each do |serialized_application|
    application = Doorkeeper::Application.new
    application.name = serialized_application[:name]
    application.redirect_uri = serialized_application[:redirect_uri]
    application.trusted = serialized_application[:trusted]
    application.save!
  end
end

def fill_users
  USERS.each_with_index do |serialized_user, index|
    user = User.new
    user.name = serialized_user[:name]
    user.save!
    if serialized_user[:meta]
      if serialized_user[:meta][:identity]
        identity_index = serialized_user[:meta][:identity]
        identity = create_single_identity identity_index
        user.identity = identity
        identity.save!
      end
      if serialized_user[:meta][:company]
        company_index = serialized_user[:meta][:company]
        company = create_single_company company_index
        user.company = company
        company.save!
      end
    end
  end
end

def fill_restaurants
  RESTAURANTS.each_with_index do |serialized_restaurant, index|
    restaurant = Restaurant.new
    restaurant.name = serialized_restaurant[:name]
    restaurant.loyalty = serialized_restaurant[:loyalty]
    restaurant.remote_order = serialized_restaurant[:remote_order]
    restaurant.conversion_rate = serialized_restaurant[:conversion_rate]
    restaurant.save!
    if serialized_restaurant[:meta]
      if serialized_restaurant[:meta][:company]
        company_index = serialized_restaurant[:meta][:company]
        company = create_single_company company_index
        company.restaurants << restaurant
        restaurant.save!
      end
      if serialized_restaurant[:meta][:address]
        address_index = serialized_restaurant[:meta][:address]
        address = create_single_address address_index
        restaurant.address = address
        address.save!
      end
    end
  end
end


def create_single_identity(index)
  serialized_identity = IDENTITIES[index]
  identity = Identity.new
  identity.username = serialized_identity[:username]
  identity.new_password = serialized_identity[:password]
  identity.email = serialized_identity[:email]
  identity.admin = !!serialized_identity[:admin]
  identity.developer = !!serialized_identity[:developer]
  identity.save!
  identity
end

def create_single_company(index)
  serialized_company = COMPANIES[index]
  company = Company.new
  company.name = serialized_company[:name]
  company.website = serialized_company[:website]
  company.save!
  if serialized_company[:meta]
    if serialized_company[:meta][:address]
      address_index = serialized_company[:meta][:address]
      address = create_single_address address_index
      company.address = address
      address.save!
    end
  end
  company
end

def create_single_address(index)
  serialized_address = ADDRESSES[index]
  address = Address.new
  address.address_1 = serialized_address[:address_1]
  address.address_2 = serialized_address[:address_2]
  address.city = serialized_address[:city]
  address.county = serialized_address[:county]
  address.country = serialized_address[:country]
  address.save!
  address
end


def create_identities
  identities = []
  IDENTITIES.each_with_index do |serialized_identity, index|
    identity = create_single_identity index
    identities << identity
  end
  identities
end

def create_companies
  companies = []
  COMPANIES.each_with_index do |serialized_company, index|
    company = create_single_company index
    companies << company
  end
  companies
end

def create_addresses
  addresses = []
  ADDRESSES.each_with_index do |serialized_address, index|
    address = create_single_address index
    addresses << address
  end
  addresses
end