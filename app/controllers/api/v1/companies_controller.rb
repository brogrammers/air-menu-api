module Api
  module V1
    class CompaniesController < BaseController
      SCOPES = {
          :index => [:admin],
          :show => [:owner],
          :update => [:owner],
          :create => [:user],
          :destroy => [:owner]
      }

      SCOPES.each do |action, scopes|
        doorkeeper_for action, :scopes => scopes
      end

      before_filter :set_company, :only => [:show, :update, :destroy]
      before_filter :check_ownership, :only => [:update, :destroy]
      before_filter :check_company_exists, :only => [:create]

      resource_description do
        name 'Companies'
        short_description 'All about the companies in the system'
        path '/companies'
        description 'The Company endpoint lets you create new companies associated with the currently logged in user.' +
                        'A company can only be created iff the logged in entity is a user.'
        error 401, 'Unauthorized, missing or invalid access token'
        error 403, 'Forbidden, valid access token, but scope is missing'
        error 404, 'Not Found, some resource could not be found'
        error 409, 'Conflict, some action can\'t be performed due to a conflict'
        error 500, 'Internal Server Error, Something went wrong!'
      end

      ################################################################################################################

      api :GET, '/companies', 'All the companies in the system'
      description "Fetches all the companies in the system. ||#{SCOPES[:index].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[companies], :index, format }

      def index
        @companies = Company.all
        respond_with @companies
      end

      ################################################################################################################

      api :GET, '/companies/:id', 'Get a company profile'
      description "Fetches a company profile. ||#{SCOPES[:show].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[companies], :show, format }

      def show
        respond_with @company
      end

      ################################################################################################################

      api :PUT, '/companies/:id', 'Update a company profile'
      description "Updates a company profile. ||#{SCOPES[:update].join(' ')}||"
      formats FORMATS
      param_group :update_company, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[companies], :update, format }

      def update
        @company = update_company @company
        respond_with @company
      end

      ################################################################################################################

      api :POST, '/companies', 'Create a new company'
      description "Creates a new company. ||#{SCOPES[:create].join(' ')}||"
      formats FORMATS
      param_group :create_company, Api::V1::BaseController
      FORMATS.each { |format| example BaseController.example_file %w[companies], :create, format }

      def create
        @company = create_company
        respond_with @company, :status => :created
      end

      ################################################################################################################

      api :DELETE, '/companies/:id', 'Delete a company profile'
      description "Deletes a company profile. ||#{SCOPES[:destroy].join(' ')}||"
      formats FORMATS
      FORMATS.each { |format| example BaseController.example_file %w[companies], :destroy, format }

      def destroy
        @company.destroy
        respond_with @company
      end

      ################################################################################################################

      private

      def set_company
        @company = Company.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render_model_not_found 'Company'
      end

      def check_ownership
        render_model_not_found 'Company' if not_admin_and?(!@user.owns(@company))
      end

      def check_company_exists
        render_conflict 'already_owns_company' if @user.company
      end

    end
  end
end