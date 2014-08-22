class InstagramWorker < ScheduledWorker

    recurrence backfill: false do
      secondly(30)
    end

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    return unless super
    token = ENV['INSTAGRAM_TOKEN']
    hashtag = ENV['HASHTAG']
    url = "https://api.instagram.com/v1/tags/#{hashtag}/media/recent?access_token=#{token}"
    logger.info "hitting #{url}"
    response = HTTParty.get(url)
    logger.info "instagram response: #{response.code}"
    body = ActiveSupport::JSON.decode(response.body)
    if body['data']
      body['data'].each do |object|
        # give objects two tries to be created
        if object['created_time'].to_f >= (last_occurrence - 60)
          photo_url = object['images']['standard_resolution']['url']
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
end
