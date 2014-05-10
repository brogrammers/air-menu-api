module Api
  module V1
    module Me
      class NotificationsController < BaseController
        SCOPES = {
            :index => [:basic]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        resource_description do
          name 'Me > Notifications'
          short_description 'All about old push notifications of the currently logged-in user'
          path '/me/devices'
          description 'The Restaurant Notifications endpoint lets you view old notifications.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/me/notifications', 'All the notifications of the currently logged-in user'
        description "Fetches all the notifications of the currently logged-in user. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[me notifications], :index, format }

        def index
          @notifications = @user.notifications
          respond_with @notifications
        end

        ################################################################################################################

      end
    end
  end
end