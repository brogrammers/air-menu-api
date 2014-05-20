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
      end unless I18n.t('notifications').class == String

    end
  end
end