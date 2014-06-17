module AirMenu
  class Settings
    class << self

      def ios_customer_certificate
        return '' if Rails.env == 'test'
        ENV['APN_CERT_CUSTOMER'] || ''
      end

      def ios_restaurant_certificate
        return '' if Rails.env == 'test'
        ENV['APN_CERT_RESTAURANT'] || ''
      end

      def uploads_dir
        ENV['UPLOADS'] || "#{Rails.root.to_s}/public"
      end

    end
  end
end