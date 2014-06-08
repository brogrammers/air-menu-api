module Api
  module V1
    class NotificationsController < BaseController
      SCOPES = {
          :update => [:basic]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

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

      ################################################################################################################

      api :PUT, '/notifications/:id', 'Update a notification in the system'
      description "Updates a notification in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param :read, %w[true false], :desc => 'Set a notification to be read.'
      FORMATS.each { |format| example BaseController.example_file %w[notifications], :update, format }

      def update
        @notification = update_notification @notification
        respond_with @notification
      end

      ################################################################################################################

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