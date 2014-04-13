module Api
  module V1
    class NotificationsController < BaseController

      doorkeeper_for :update, :scopes => [:basic]

      before_filter :set_notification, :only => [:update]
      before_filter :check_ownership, :only => [:update]

      resource_description do
        name 'Notifications'
        short_description 'Set your Notifications to be read and dismissed.'
        path '/orders'
        description 'The Notifications endpoint lets you set your notifications as read.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      api :PUT, '/notifications/:id', 'Update a notification in the system'
      description 'Updates a notification in the system. ||basic||'
      formats [:json, :xml]
      param :read, [true, false], :desc => 'Set a notification to be read.'
      example File.read("#{Rails.root}/public/docs/api/v1/notifications/update.json")
      example File.read("#{Rails.root}/public/docs/api/v1/notifications/update.xml")
      def update
        @notification.read = params[:read] || @notification.read
        @notification.save!
        respond_with @notification
      end

      private

      def set_notification
        @notification = Notification.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Notification'
      end

      def check_ownership
        render_model_not_found 'Notification' if not_admin_and?(!@user.owns(@notification))
      end

    end
  end
end