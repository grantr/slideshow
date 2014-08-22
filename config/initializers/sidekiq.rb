redis_url = ENV['REDISCLOUD_URL'] || ENV['BOXEN_REDIS_URL']
Sidekiq.configure_server do |config|
    config.redis = { :url => redis_url }
    config.poll_interval = 5
end

Sidekiq.configure_client do |config|
    config.redis = { :url => redis_url }
end

Sidetiq.configure do |config|
  config.utc = true
end
