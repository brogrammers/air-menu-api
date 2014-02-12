module Api
  module V1
    class BaseController < ApplicationController

      resource_description do
        api_version 'v1'
        app_info 'AirMenu Api v1 is the first API documentation by the AirMenu team. Find out how to use our System. ' +
                 'Getting Started'
        api_base_url '/api/v1'
      end

      def render_route_not_found
        render @format => {:error => {:messages => ['Route not found']}}, :status => :not_found
      end

      def render_model_not_found(model_name = nil)
        model_name = model_name ? model_name : 'Model'
        render @format => {:error => {:messages => ["#{model_name} not found"]}}, :status => :not_found
      end

      def render_forbidden(error = nil)
        render @format => {:error => {:messages => ['Forbidden']}}, :status => :forbidden
      end

      rescue_from ActiveRecord::RecordNotFound do |exception|
        render_model_not_found
      end

      protected

      def create_company
        company = Company.new
        company.name = params[:name]
        company.website = params[:website]
        company.save!
        company
      end

      def create_address
        address = Address.new
        address.address_1 = params[:address_1]
        address.address_2 = params[:address_2]
        address.city = params[:city]
        address.county = params[:county]
        address.state = params[:state]
        address.country = params[:country]
        address.save!
        address
      end

      def create_restaurant
        restaurant = Restaurant.new
        restaurant.name = params[:name]
        restaurant.loyalty = false
        restaurant.remote_order = false
        restaurant.conversion_rate = 0.0
        restaurant.company_id = params[:company_id]
        restaurant.save!
        restaurant
      end

      def create_user
        user = User.new
        user.name = params[:name]
        user.save!
        user
      end

      def create_identity
        identity = Identity.new
        identity.username = params[:username]
        identity.new_password = params[:password]
        identity.email = params[:email]
        identity.save!
        identity
      end

    end
  end
end