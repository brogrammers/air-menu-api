module Doorkeeper
  module Helpers
    module Controller

      def server
        @server ||= Server.new(self, params)
      end

    end
  end
end