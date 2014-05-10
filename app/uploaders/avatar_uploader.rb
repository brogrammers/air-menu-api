# encoding: utf-8
require 'carrierwave'
require "#{Rails.root}/lib/air_menu"

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{AirMenu::Settings.uploads_dir}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def relative_path_url
    if url
      filename = url.split('/').pop
      "/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/#{filename}"
    else
      nil
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [50, 50]
  end

  version :medium do
    process :resize_to_fit => [550, 550]
  end

  version :large do
    process :resize_to_fit => [1000, 1000]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
      "avatar.#{original_filename.split('.').pop}"
    else
      nil
    end
  end

end
