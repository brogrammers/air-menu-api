module AirMenu
  class NotificationDispatcher
    module Strategy
      class IOS

        def initialize
          @pusher = Grocer.pusher(
              certificate: AirMenu::Settings.ios_certificate,
              gateway: 'gateway.sandbox.push.apple.com',
              port: 2195,
              retries: 3
          )
        end

        def dispatch(token, message, count)
          new_notification = notification(token, message, count)
          @pusher.push(new_notification) rescue false
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