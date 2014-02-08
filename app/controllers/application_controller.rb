class ApplicationController < ActionController::Base
  before_filter :find_current_user

  respond_to :json, :xml

  resource_description do
    api_versions 'v1'
  end

  protected

  def find_current_user
    if doorkeeper_token
      @identity = Identity.find doorkeeper_token.resource_owner_id
      @user = @identity.identifiable
    end
  end

  def doorkeeper_unauthorized_render_options
    # TODO: need better ruling!
    type = :json
    type = :xml if request.headers['Accept'] =~ /application\/xml/
    {type => {:error => {:messages => ['Unauthorized']}}}
  end

  def doorkeeper_forbidden_render_options
    # TODO: need better ruling!
    type = :json
    type = :xml if request.headers['Accept'] =~ /application\/xml/
    {type => {:error => {:messages => ['Forbidden']}}}
  end
end
