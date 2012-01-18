if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.production?
  CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAJC7GQ35VMU5OVCEA',       # required
      :aws_secret_access_key  => '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',       # required
    }
    config.fog_directory  = 'usnapus'                     # required
    # config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
    # config.fog_public     = false                                   # optional, defaults to true
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    
    #For heroku
    config.cache_dir = "carrierwave"
    config.root = Rails.root.join('tmp')
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAJC7GQ35VMU5OVCEA',       # required
      :aws_secret_access_key  => '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',       # required
    }
    config.fog_directory  = 'usnapus-dev'                     # required
    # config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
    # config.fog_public     = false                                   # optional, defaults to true
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
