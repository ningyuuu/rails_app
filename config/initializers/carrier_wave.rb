require 'fog/aws'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog,
    config.fog_use_ssl_for_aws = true,
    config.fog_public     = true
    config.fog_attributes = { 'Cache-Control': 'max-age=315576000' }
    config.asset_host = 'https://s3.amazonaws.com/website'
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end