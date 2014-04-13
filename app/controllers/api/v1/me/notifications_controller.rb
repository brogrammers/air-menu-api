module Api
  module V1
    module Me
      class NotificationsController < BaseController

        doorkeeper_for :index, :scopes => [:basic]

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

        api :GET, '/me/notifications', 'All the notifications of the currently logged-in user'
        description 'Fetches all the notifications of the currently logged-in user. ||basic||'
        formats [:json, :xml]
        example File.read("#{Rails.root}/public/docs/api/v1/me/notifications/index.json")
        example File.read("#{Rails.root}/public/docs/api/v1/me/notifications/index.xml")
        def index
          @notifications = @user.notifications
          respond_with @notifications
        end

      end
    end
  end
end