module Doorkeeper
  class DoorkeeperFor
    def validate_token(token)
      return false unless token
      token.accessible?
    end

    def validate_token_scopes(token)
      return true if @scopes.blank?
      if token
        token.scopes.any? { |scope| @scopes.include? scope }
      else
        false
      end
    end
  end
end