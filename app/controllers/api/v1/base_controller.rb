module Api
  module V1
    class BaseController < ApplicationController
      include BaseHelper

      after_filter :webhook

      resource_description do
        api_version 'v1'
        app_info File.read("#{Rails.root}/doc/v1.txt")
        api_base_url '/api/v1'
      end

      def webhook
        if @restaurant && Rails.env != 'test'
          Thread.new do
            Webhook.where(:restaurant_id => @restaurant.id, :on_action => params[:action], :on_method => params[:controller]).each do |webhook|
              webhook.perform!
            end
          end
        end
      end

      def self.example_file(resources, action, format)
        File.read("#{Rails.root}/public/docs/api/v1/#{resources.join('/')}/#{action}.#{format}") rescue ''
      end

      {:create => true, :update => false}.each do |action, required|

        def_param_group :"#{action}_address" do
          param :address_1, String, :desc => 'Address address line 1', :required => required
          param :address_2, String, :desc => 'Address address line 2', :required => required
          param :city, String, :desc => 'Address city', :required => required
          param :county, String, :desc => 'Address county', :required => required
          param :state, String, :desc => 'Address state (only US)'
          param :country, String, :desc => 'Address country', :required => required
        end

        def_param_group :"#{action}_restaurant" do
          param :name, String, :desc => 'Restaurant Name', :required => required
          param :description, String, :desc => 'Restaurant Description', :required => required
          param :category, String, :desc => 'Restaurant Category', :required => required
          param :avatar, ActionDispatch::Http::UploadedFile, :desc => 'Image file via multipart form'
          param_group :"#{action}_address", Api::V1::BaseController
          param_group :"#{action}_location", Api::V1::BaseController
        end

        def_param_group :"#{action}_location" do
          param :latitude, :latitude, :desc => 'Location latitude', :required => required
          param :longitude, :longitude, :desc => 'Location longitude', :required => required
        end

        def_param_group :"#{action}_credit_card" do
          param :number, String, :desc => 'Credit Card number (16 digits)', :required => required
          param :card_type, %w[VISA MASTERCARD], :desc => 'Credit Card type', :required => required
          param :month, String, :desc => 'Credit Card expiry month', :required => required
          param :year, String, :desc => 'Credit Card expiry year', :required => required
          param :cvc, String, :desc => 'Credit Card CVC', :required => required
        end

        def_param_group :"#{action}_device" do
          param :name, String, 'Device name', :required => required
          param :uuid, String, 'Device UUID', :required => required
          param :token, String, 'Device token'
          param :platform, :device_platform, 'Device platform (currently only iOS)', :required => required
        end

        def_param_group :"#{action}_menu_item" do
          param :name, String, :desc => 'Name of Menu Item', :required => required
          param :description, String, :desc => 'Description of Menu Item', :required => required
          param :price, :price, :desc => 'Price of Menu Item', :required => required
          param :currency, :currency, :desc => 'Currency of Menu Item', :required => required
          param :staff_kind_id, String, :desc => 'Staff Kind handling this menu section'
          param :avatar, ActionDispatch::Http::UploadedFile, :desc => 'Image file via multipart form'
        end

        def_param_group :"#{action}_menu_section" do
          param :name, String, :desc => 'Name of Menu Section', :required => required
          param :description, String, :desc => 'Description of Menu Section', :required => required
          param :staff_kind_id, String, :desc => 'Staff Kind handling this menu section', :required => required
        end

        def_param_group :"#{action}_menu" do
          param :name, String, :desc => 'Menu name', :required => required
          param :active, String, :desc => 'Make menu active. ||owner add_active_menus||'
        end

        def_param_group :"#{action}_order" do
          param :table_number, String, :desc => 'Table number (Only for Staff Members)'
        end

        def_param_group :"#{action}_order_item" do
          param :comment, String, :desc => 'Set a comment on the order item', :required => required
          param :count, :integer, :desc => 'Set how many times you want to order the menu item', :required => required
          param :menu_item_id, :integer, :desc => 'Set menu item', :required => required
        end

        def_param_group :"#{action}_group" do
          param :name, String, 'Group name', :required => required
          param :device_id, :integer, 'Group Device', :required => required
          param :staff_members, String, :desc => 'Staff member ids separated with whitespace (Will be reset each time)'
        end

        def_param_group :"#{action}_staff_kind" do
          param :name, String, :desc => 'Staff kind name', :required => required
          param :accept_orders, :bool, :desc => 'Staff kind can accept orders', :required => required
          param :accept_order_items, :bool, :desc => 'Staff kind can accept order items', :required => required
          param :scopes, String, :desc => 'Staff Kind scope names separated with whitespace (Will be reset each time)'
        end

        def_param_group :"#{action}_staff_member" do
          param :name, String, 'Staff Member name', :required => required
          param :username, String, 'Staff Member username', :required => required
          param :password, String, 'Staff Member password', :required => required
          param :email, String, 'Staff Member email', :required => required
          param :staff_kind_id, String, 'Staff Members staff kind id', :required => required
          param :device_id, :integer, 'Staff Member Device'
          param :avatar, ActionDispatch::Http::UploadedFile, :desc => 'Image file via multipart form'
        end

        def_param_group :"#{action}_company" do
          param :name, String, :desc => 'Companies name', :required => required
          param :website, String, :desc => 'Companies website', :required => required
          param_group :"#{action}_address", Api::V1::BaseController
        end

        def_param_group :"#{action}_user" do
          param :username, String, :desc => 'Users username', :required => required if action == :create
          param :name, String, :desc => 'Users full name', :required => required
          param :email, String, :desc => 'Users email', :required => required
          param :password, String, :desc => 'New password', :required => required
          param :phone, String, :desc => 'New phone number', :required => required
          param :avatar, ActionDispatch::Http::UploadedFile, :desc => 'Image file via multipart form'
        end

        def_param_group :"#{action}_opening_hour" do
          param :day, :day, :desc => 'Day', :required => required
          param :start, :start_opening_hour, :desc => 'Time ISO8601', :required => required
          param :end, :hour_offset, :desc => 'Hour Offset', :required => required
        end

        def_param_group :"#{action}_webhook" do
          param :path, String, :desc => 'Webhook path', :required => required
          param :host, String, :desc => 'Webhook host', :required => required
          param :params, :json_string, :desc => 'Webhook params', :required => required
          param :headers, :json_string, :desc => 'Webhook headers', :required => required
          param :on_action, String, :desc => 'Webhook on action', :required => required
          param :on_method, String, :desc => 'Webhook on method', :required => required
        end

      end

      def_param_group :search_restaurant do
        param :latitude, String, :desc => 'Latitude', :required => true
        param :longitude, String, :desc => 'Longitude', :required => true
        param :offset, String, :desc => 'Offset', :required => true
        param :category, String, :desc => 'Category'
      end

      def_param_group :create_payment do
        param :credit_card_id, :integer, :desc => 'Credit Card id (required for user, not allowed by staff member)'
      end

      def_param_group :create_review do
        param :subject, String, :desc => 'Subject', :required => true
        param :message, String, :desc => 'Message', :required => true
        param :rating, :rating, :desc => 'Rating (1-5)', :required => true
      end

    end
  end
end