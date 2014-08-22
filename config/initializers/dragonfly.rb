require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  analyser :orientation do |content|
    identify_command = content.env[:identify_command] || 'identify'
    details = content.shell_eval do |path|
      "#{identify_command} -ping -format '%[EXIF:Orientation] %[orientation]' #{path}"
    end
    # exif_orientation, orientation = details.split
    # {
    #   exif_orientation: exif_orientation,
    #   orientation: orientation
    # }
  end

  protect_from_dos_attacks true
  secret ENV['DRAGONFLY_SECRET']

  url_format "/media/:job/:name"

  if Rails.env.production?
    require 'dragonfly/s3_data_store'
    datastore :s3,
      bucket_name: ENV['DRAGONFLY_BUCKET'],
      access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
      secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']
  else
    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
