Doorkeeper.configure do
  # Change the ORM that doorkeeper will use.
  # Currently supported options are :active_record, :mongoid2, :mongoid3, :mongo_mapper
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    # raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
    # Put your resource owner authentication logic here.
    # Example implementation:
    #   User.find_by_id(session[:user_id]) || redirect_to(new_user_session_url)
  end

  admin_authenticator do
    # raise "Please configure the admin authenticator"
    # Admin.find_by_id(session[:admin_id]) || redirect_to(new_admin_session_url)
  end

  resource_owner_from_credentials do |routes|
    client = Doorkeeper::Application.authenticate(params[:client_id], params[:client_secret])
    identity = Identity.find_by_username(params[:username])
    if client && identity && client.trusted && identity.match_password(params[:password])
      identity
    else
      nil
    end
  end

  skip_authorization do |resource_owner, client|
    false
  end

  authorization_code_expires_in 10.minutes
  access_token_expires_in 48.hours
  use_refresh_token
  #enable_application_owner :confirmation => false
  client_credentials :from_params
  access_token_methods :from_bearer_authorization
  test_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'

  default_scopes  :basic
  optional_scopes :admin,
                  :trusted,
                  :user,
                  :developer,
                  :owner,
                  :get_menus,
                  :add_menus,
                  :add_active_menus,
                  :get_current_orders,
                  :add_orders,
                  :update_orders,
                  :get_groups,
                  :create_groups,
                  :get_devices,
                  :create_devices,
                  :get_staff_kinds,
                  :create_staff_kinds,
                  :get_staff_members,
                  :create_staff_members,


  realm 'AirMenuApi'
end
