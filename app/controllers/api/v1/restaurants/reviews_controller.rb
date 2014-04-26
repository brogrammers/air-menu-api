module Api
  module V1
    module Restaurants
      class ReviewsController < BaseController
        SCOPES = {
            :index => [:admin, :user],
            :create => [:admin, :user]
        }

        SCOPES.each do |action, scopes|
          doorkeeper_for action, :scopes => scopes
        end

        before_filter :set_restaurant, :only => [:index, :create]
        before_filter :check_existing_review, :only => [:create]

        resource_description do
          name 'Restaurants > Reviews'
          short_description 'All about reviews of restaurants'
          path '/restaurants/:id/reviews'
          description 'The Restaurant Reviews endpoint lets you create new reviews for restaurants.' +
                          'Only a user can create reviews for restaurants.'
          error 401, 'Unauthorized, missing or invalid access token'
          error 403, 'Forbidden, valid access token, but scope is missing'
          error 404, 'Not Found, some resource could not be found'
          error 500, 'Internal Server Error, Something went wrong!'
        end

        ################################################################################################################

        api :GET, '/restaurants/:id/reviews', 'All the reviews of a restaurant'
        description "Fetches all the reviews of a restaurant. ||#{SCOPES[:index].join(' ')}||"
        formats FORMATS
        FORMATS.each { |format| example BaseController.example_file %w[restaurants reviews], :index, format }

        def index
          @reviews = @restaurant.reviews
          respond_with @reviews
        end

        ################################################################################################################

        api :POST, '/restaurants/:id/reviews', 'Create a review for a restaurant'
        description "Creates a review for a restaurant. ||#{SCOPES[:create].join(' ')}||"
        formats FORMATS
        param_group :create_review, Api::V1::BaseController
        FORMATS.each { |format| example BaseController.example_file %w[restaurants reviews], :create, format }

        def create
          @review = create_review @restaurant, @user
          respond_with @review, :status => :created
        end

        ################################################################################################################

        private

        def set_restaurant
          @restaurant = Restaurant.find params[:restaurant_id]
        rescue ActiveRecord::RecordNotFound
          render_model_not_found 'Restaurant'
        end

        def check_existing_review
          render_forbidden 'already_submitted' if @user.class == User && @user.written_review?(@restaurant)
        end

      end
    end
  end
end