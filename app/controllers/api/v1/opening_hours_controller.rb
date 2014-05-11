module Api
  module V1
    class OpeningHoursController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:admin, :user, :owner, :get_opening_hours],
          :update => [:admin, :owner, :update_opening_hours],
          :destroy => [:admin, :owner, :delete_opening_hours]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_opening_hour, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:update, :destroy]

      resource_description do
        name 'Opening Hours'
        short_description 'All about Opening Hours in the system'
        path '/staff_kinds'
        description 'The Opening Hours endpoint lets you inspect opening hours in the system.' +
                        'Only a users with the right scope can inspect opening hours.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/opening_hours', 'All the opening hours in the system'
      description "Fetches all the opening hours in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[opening_hours], :index, format }

      def index
        @opening_hours = OpeningHour.all
        respond_with @opening_hours
      end

      ################################################################################################################

      api :GET, '/opening_hours/:id', 'Get an opening hour in the system'
      description "Gets an opening hour in the system. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[opening_hours], :show, format }

      def show
        respond_with @opening_hour
      end

      ################################################################################################################

      api :PUT, '/opening_hours/:id', 'Update an opening hour in the system'
      description "Updates an opening hour in the system. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_opening_hour, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[opening_hours], :update, format }

      def update
        update_opening_hour @opening_hour
        respond_with @opening_hour
      end

      ################################################################################################################

      api :DELETE, '/opening_hours/:id', 'Delete an opening hour in the system'
      description "Deletes an opening hour in the system. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[opening_hours], :destroy, format }

      def destroy
        @opening_hour.destroy
        respond_with @opening_hour
      end

      ################################################################################################################

      private

      def set_opening_hour
        @opening_hour = OpeningHour.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'OpeningHour'
      end

      def check_ownership
        render_model_not_found 'OpeningHour' if not_admin_and?(!@user.owns(@opening_hour.restaurant))
      end

    end
  end
end