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
      @user.devices.each do |device|
        @strategy.dispatch(device.token, notification.content, (@user.unread_count))
      end
    rescue NoMethodError
      Rails.logger.info "Staff Member #{@user.name} #{@user.class}"
      Rails.logger.info "Staff Member Device #{@user.device.name}" if @user.device
      Rails.logger.info "Staff Member Token #{@user.device.token}" if @user.device
      if @user.device
        Rails.logger.info 'inside single device'
        @strategy.dispatch(@user.device.token, notification.content, (@user.unread_count))
      elsif @user.group && @user.group.device
        Rails.logger.info 'inside group device'
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