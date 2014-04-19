module AirMenu
  class ScopeDistributor

    def initialize(params, identity, trusted=false)
      @requested_scopes = (params[:scope] || '').split ' '
      @identity = identity
      @scopes = ['basic']
      @scopes = @scopes.concat ['trusted'] if trusted && @requested_scopes.include?('trusted')
      assemble_scopes
    end

    def assemble_scopes
      @identity.identifiable.scopes.each do |scope|
        scope = scope.name if scope.class == Scope
        @scopes <<(scope) if @requested_scopes.include? scope
      end
      individual_scopes
    end

    def individual_scopes
      @scopes <<('admin') if @identity.admin && @requested_scopes.include?('admin')
      @scopes <<('developer') if @identity.developer && @requested_scopes.include?('developer')
    end

    def scope_string
      @scopes.join ' '
    end

  end
end