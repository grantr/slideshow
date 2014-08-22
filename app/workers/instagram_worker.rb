class InstagramWorker < ScheduledWorker

  recurrence backfill: false do
    secondly(30)
  end

  def get_token
    token = nil
    Sidekiq.redis_pool.with do |redis|
      token = redis.get 'instagram_token'
    end
    token || ENV['INSTAGRAM_TOKEN']
  end

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    return unless super
    token = get_token
    hashtag = ENV['HASHTAG']
    client = Instagram.client(access_token: token)
    logger.info "checking instagram hashtag"
    media = client.tag_recent_media(hashtag)
    media.each do |post|
      # give objects two tries to be created
      if post.created_time.to_i >= (last_occurrence - 60)
        photo_url = post.images.standard_resolution.url
        begin
          photo = Photo.new(url: photo_url, source: 'instagram')
          photo.image_url = photo_url

          if photo.save
            logger.info "Created instagram photo: #{photo.inspect}"
          end
        rescue ActiveRecord::RecordNotUnique
          # we created this one already, no big deal
        end
      end
    end
  end
end
