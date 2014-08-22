class InstagramPhotoboothWorker < ScheduledWorker

    recurrence backfill: false do
      secondly(30)
    end

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    return unless super
    token = ENV['INSTAGRAM_TOKEN']
    user_id = ENV['INSTAGRAM_USER_ID']
    client = Instagram.client(access_token: token)
    logger.info "checking instagram photo booth"
    media = client.user_recent_media(user_id)
    media.each do |post|
        # give objects two tries to be created
        if post.created_time.to_i >= (last_occurrence - 60)
          photo_url = post.images.standard_resolution.url
          begin
            photo = Photo.new(url: photo_url, source: 'instagram-photobooth')
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
end
