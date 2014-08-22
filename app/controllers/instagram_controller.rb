class InstagramController < ApplicationController
  def connect
    redirect_to Instagram.authorize_url(redirect_uri: redirect_uri)
  end

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: redirect_uri)

    Sidekiq.redis_pool.with do |redis|
      redis.set 'instagram_token', response.access_token
    end
    logger.info "Stored instagram token #{response.access_token}"
    head :ok
  end

  private
  def redirect_uri
    ENV['REDIRECT_HOST'] + '/instagram/callback'
  end
end
