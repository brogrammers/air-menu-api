module Doorkeeper
  class Server

    def initialize(context = nil, parameters = nil)
      @context = context
      @parameters = parameters
    end

    def parameters
      @parameters
    end

  end
end