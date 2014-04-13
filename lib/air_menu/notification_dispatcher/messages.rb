module AirMenu
  class NotificationDispatcher
    module Messages

      I18n.t('notifications').each do |action, translation|
        eval(
            <<-eos
  def #{action}
    '#{translation}'
  end
        eos
        )
      end

    end
  end
end