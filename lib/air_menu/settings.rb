module AirMenu
  class Settings
    class << self

      def ios_certificate
        ENV['APN_CERT'] || ''
      end

    end
  end
end