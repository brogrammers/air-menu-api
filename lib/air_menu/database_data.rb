APPLICATIONS = [
    {
        :name => 'iOS Restaurant',
        :redirect_uri => 'http://localhost/'
    },
    {
        :name => 'iOS Customer',
        :redirect_uri => 'http://localhost/'
    }
]

USERS = [
    {
        :name => 'Max Hoffmann'
    }
]

IDENTITIES = [
    {
        :username => 'tsov',
        :password => 'davinci',
        :email => 'tsov@me.com'
    }
]

COMPANIES = [
    {
        :name => 'Brogrammers',
        :website => 'http://brogrammers.info'
    }
]

ADDRESSES = [
    {
        :address_1 => 'SomeOffice House 45',
        :address_2 => 'Business Campus',
        :city => 'Dublin',
        :county => 'Dublin',
        :country => 'Ireland'
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
    application.save!
  end
end

def fill_users
  identities = create_identities
  companies = create_companies
  addresses = create_addresses
  USERS.each_with_index do |serialized_user, index|
    user = User.new
    user.name = serialized_user[:name]
    user.save!
    user.identity = identities[index]
    user.company = companies[index]
    identities[index].save!
    companies[index].save!
    user.company.address = addresses[index]
    addresses[index].save!
  end
end


def create_identities
  identities = []
  IDENTITIES.each do |serialized_identity|
    identity = Identity.new
    identity.username = serialized_identity[:username]
    identity.new_password = serialized_identity[:password]
    identity.email = serialized_identity[:email]
    identity.save!
    identities << identity
  end
  identities
end

def create_companies
  companies = []
  COMPANIES.each do |serialized_company|
    company = Company.new
    company.name = serialized_company[:name]
    company.website = serialized_company[:website]
    company.save!
    companies << company
  end
  companies
end

def create_addresses
  addresses = []
  ADDRESSES.each do |serialized_address|
    address = Address.new
    address.address_1 = serialized_address[:address_1]
    address.address_2 = serialized_address[:address_2]
    address.city = serialized_address[:city]
    address.county = serialized_address[:county]
    address.country = serialized_address[:country]
    address.save!
    addresses << address
  end
  addresses
end