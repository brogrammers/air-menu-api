class ApplicationController < ActionController::Base
  before_filter :find_current_user
  before_filter :determine_format

  respond_to :json, :xml

  resource_description do
    api_versions 'v1'
  end

  protected

  def find_current_user
    if doorkeeper_token
      @identity = Identity.find doorkeeper_token.resource_owner_id
      @user = @identity.identifiable
      @scopes = doorkeeper_token.scopes
    end
  end

  def determine_format
    @format = :json
    @format = :xml if request.headers['Accept'] == /application\/xml/
  end

  def scope_exists?(scope)
    @scopes.exists? scope
  end

  def admin?
    scope_exists? 'admin'
  end

  def admin_and?(condition)
    admin? and condition
  end

  def not_admin_and?(condition)
    !admin? and condition
  end

  def render_oauth_error(error)
    render @format => error, :status => :bad_request
  end

  def doorkeeper_unauthorized_render_options(error)
    {@format => {:error => {:code => 'unauthorized'}}}
  end

  def doorkeeper_forbidden_render_options(error)
    {@format => {:error => {:code => 'route_not_found'}}, :status => :not_found}
  end
end
