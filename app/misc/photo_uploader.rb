# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  #For delaying the processing
  include ::CarrierWave::Backgrounder::DelayStorage

  # Choose what kind of storage to use for this uploader:
  unless Rails.env.test?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "events/#{model.event.s3_token}/photos/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #

  process :fix_exif_rotation

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumbnail do
    process :resize_to_fill => [200, 200]
  end
  version :xga do
    process :resize_to_fit => [1024, 768]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end