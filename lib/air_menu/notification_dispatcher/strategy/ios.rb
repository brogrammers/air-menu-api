module AirMenu
  class NotificationDispatcher
    module Strategy
      class IOS

        def initialize
          @pushers = [AirMenu::Settings.ios_customer_certificate, AirMenu::Settings.ios_restaurant_certificate].inject([]) do |pushers, certificate|
            pushers.push(Grocer.pusher(
                certificate: certificate,
                gateway: 'gateway.sandbox.push.apple.com',
                port: 2195,
                retries: 3
            ))
          end
        end

        def dispatch(token, message, count, type)
          return unless token.is_a?(String) && !token.empty?
          new_notification = notification(token, message, count)
          @pushers.first.push(new_notification) rescue false if type == User
          @pushers.last.push(new_notification) rescue false if type == StaffMember
        end

        def notification(token, message, count)
          @notification ||= Grocer::Notification.new(
              device_token:      token,
              alert:             message,
              badge:             count,
              sound:             "siren.aiff",
              expiry:            Time.now + 60*60,
              identifier:        1234,
              content_available: true
          )
        end

      end
    end
  end
end