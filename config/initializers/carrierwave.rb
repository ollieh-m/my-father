CarrierWave.configure do |config|

  config.enable_processing = true
  if Rails.env.test?
    config.storage = :file
    config.root = Rails.root.join("public")
    config.cache_dir = "#{Rails.env}/tmp"
  elsif Rails.env.development?
    config.storage = :file
    config.root = Rails.root.join("public")
    config.cache_dir = "#{Rails.env}/tmp"
  elsif Rails.env.production?
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider:              "AWS",
      aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region:                ENV["AWS_REGION"]
    }
    config.fog_public     = false
    config.fog_attributes = { cache_control: "public, max-age=#{1.hour.to_i}" }

    config.fog_directory = "myfather"
    config.storage = :fog
    config.cache_storage = :fog
    config.cache_dir = "#{Rails.env}/tmp"
  end

end
