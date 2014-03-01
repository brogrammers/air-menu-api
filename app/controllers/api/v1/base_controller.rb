module Api
  module V1
    class BaseController < ApplicationController

      resource_description do
        api_version 'v1'
        app_info File.read("#{Rails.root}/public/docs/api/v1/desc.txt")
        api_base_url '/api/v1'
      end

      def render_route_not_found
        render @format => {:error => {:code => 'route_not_found'}}, :status => :not_found
      end

      def render_model_not_found(model_name = nil)
        model_name = model_name ? model_name : 'unknown'
        render @format => {:error => {:code => 'model_not_found', :model => model_name}}, :status => :not_found
      end

      def render_forbidden(error = nil)
        error_message = error || 'unknown'
        render @format => {:error => {:code => 'forbidden', :message => error_message}}, :status => :forbidden
      end

      def render_conflict(error = nil)
        error_message = error || 'unknown'
        render @format => {:error => {:code => 'conflict', :message => error_message}}, :status => :conflict
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
        identity.admin = false
        identity.developer = false
        identity.save!
        identity
      end

      def create_order(restaurant)
        order = Order.new
        order.user = @user
        order.restaurant = restaurant
        order.prepared = false
        order.served = false
        order.save!
        order
      end

      def create_order_item(order, menu_item)
        order_item = OrderItem.new
        order_item.comment = params[:comment]
        order_item.order = order
        order_item.menu_item = menu_item
        order_item.count = params[:count].to_i
        order_item.served = false
        order_item.save!
        order_item
      end

      def create_staff_kind(restaurant)
        staff_kind = StaffKind.new
        staff_kind.name = params[:name]
        staff_kind.restaurant = restaurant
        staff_kind.save!
        staff_kind
      end

      def create_staff_member(restaurant, staff_kind)
        staff_member = StaffMember.new
        staff_member.name = params[:name]
        staff_member.restaurant = restaurant
        staff_member.staff_kind = staff_kind
        identity = create_identity
        staff_member.identity = identity
        staff_member.save!
        identity.save!
        staff_member
      end

    end
  end
end