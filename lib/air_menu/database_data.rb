#encoding: utf-8

Dir["#{Rails.root}/lib/air_menu/database_data/*.rb"].each {|file| require file }

require 'json'
require 'pp'

module AirMenu
  class DatabaseData

    def fill_database
      Dir["#{Rails.root}/lib/air_menu/database_data/*.rb"].each do |file|
        key = file.split('/').last.split('.').first
        create_model key.to_s, "AirMenu::DatabaseData::#{key.upcase}".constantize
      end
    end

    private

    def create_model(model, data)
      data.each_with_index do |serialized_object, index|
        object = get_instance model, index+1
        serialized_object.each do |key, value|
          next if key == :id || key == 'id'
          eval("object.#{key} = value")
        end
        object.save!
      end
    end

    MAPPER = {
        'Application' => 'Doorkeeper::Application'
    }

    def get_instance(name, index)
      constant = proper_class_name(name).constantize
      instance = constant.find index
      instance
    rescue ActiveRecord::RecordNotFound
      constant.new
    end

    def proper_class_name(name)
      converted_name = convert_to_constant_string name
      MAPPER[converted_name] ? MAPPER[converted_name] : converted_name
    end

    def convert_to_constant_string(name)
      parts = name.downcase.split '_'
      parts.each_with_index { |part, index| parts[index] = part.camelize }
      parts.join ''
    end

  end
end