module Api
  module V1
    module Companies
      class RestaurantsController < BaseController
        SCOPES = {
            :index => [:admin, :owner],
            :create => [:admin, :owner]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_company, :only => [:index, :create]
        before_filter :check_ownership, :only => [:create]

        resource_description do
          name 'Companies > Restaurants'
          short_description 'All about the restaurants in of companies'
          path '/companies/:id/restaurants'
          description 'The Company Restaurants endpoint lets you create new restaurants for a company.' +
                          'Only an owner can create restaurants.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/companies/:id/restaurants', 'All the restaurants of a company'
        description "Fetches all the restaurants in the system. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[companies restaurants], :index, format }

        def index
          @restaurants = @company.restaurants
          respond_with @restaurants
        end

        ################################################################################################################

        api :POST, '/companies/:id/restaurants', 'Create a new restaurant'
        description "Creates a new company. Only owners can create new restaurants. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_restaurant, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[companies restaurants], :create, format }

        def create
          @restaurant = create_restaurant @company
          respond_with @restaurant, :status => :created
        end

        ################################################################################################################

        private

        def set_company
          @company = Company.find params[:company_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Company'
        end

        def check_ownership
          render_forbidden 'ownership_failure' if not_admin_and?(!@user.owns(@company))
        end

      end
    end
  end
end