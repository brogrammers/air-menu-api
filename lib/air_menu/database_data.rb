def fill_scopes
  %w{get_all_current_orders get_all_orders create_new_orders cancel_order}.each do |name|
    scope = Scope.new
    scope.name = name
    scope.save!
  end
end

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

def fill_oauth_applications
  APPLICATIONS.each do |serialized_application|
    application = Doorkeeper::Application.new
    application.name = serialized_application[:name]
    application.redirect_uri = serialized_application[:redirect_uri]
    application.save!
  end
end