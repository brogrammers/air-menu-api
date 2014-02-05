class ApplicationController < ActionController::Base
  before_filter :find_current_user

  respond_to :json, :xml

  resource_description do
    api_versions 'v1'
  end

  protected

  def find_current_user
    @identity = Identity.find doorkeeper_token.resource_owner_id
    @user = @identity.identifiable
  end
end
