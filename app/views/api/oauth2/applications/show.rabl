object @application => :oauth_application

attributes :id, :name, :redirect_uri

attributes :trusted if @scopes.exists? 'admin'

node :client_id do |application|
    application.uid
end

node :client_secret do |application|
    application.secret
end