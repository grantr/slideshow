class InstagramPhotoboothWorker < ScheduledWorker

    recurrence backfill: false do
      secondly(30)
    end

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    return unless super
    token = ENV['INSTAGRAM_TOKEN']
    user_id = ENV['INSTAGRAM_USER_ID']
    url = "https://api.instagram.com/v1/users/#{user_id}/media/recent?access_token=#{token}"
    logger.info "hitting #{url}"
    response = HTTParty.get(url)
    body = ActiveSupport::JSON.decode(response.body)
    if body['data']
      body['data'].each do |object|
        # give objects two tries to be created
        if object['created_time'].to_f >= (last_occurrence - 60)
          photo_url = object['images']['standard_resolution']['url']
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
