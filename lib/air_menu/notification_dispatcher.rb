require File.join(File.dirname(__FILE__), 'notification_dispatcher', 'messages')
require File.join(File.dirname(__FILE__), 'notification_dispatcher', 'strategy')

module AirMenu
  class NotificationDispatcher
    include Messages

    def initialize(user, action)
      @user = user
      get_message(action)
      @strategy = Strategy::IOS.new
    end

    def dispatch
      return unless @message && @user
      notification = create_notification
      Rails.logger.info "notification #{@message}"
      Rails.logger.info "devices count #{@user.devices}"
      @user.devices.each do |device|
        Rails.logger.info "device token #{device.token}"
        @strategy.dispatch(device.token, notification.content, (@user.unread_count))
      end
    rescue NoMethodError
      if @user.device
        @strategy.dispatch(@user.device.token, notification.content, (@user.unread_count))
      elsif @user.group && @user.group.device
        @strategy.dispatch(@user.group.device.token, notification.content, (@user.unread_count))
      end
    end

    def create_notification
      notification = Notification.new
      notification.content = @message
      notification.read = false
      notification.remindable = @user
      notification.save!
      notification
    end

    def get_message(action)
      @message = self.send(action)
    rescue NoMethodError
      @message = nil
    end

  end
end