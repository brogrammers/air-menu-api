module AirMenu
  class Settings
    class << self

      def ios_certificate
        ENV['APN_CERT'] || ''
      end

      def uploads_dir
        ENV['UPLOADS'] || "#{Rails.root.to_s}/public"
      end

    end
  end
end