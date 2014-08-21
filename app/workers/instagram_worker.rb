class InstagramWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: false do
    secondly(30)
  end

  def perform(last_occurrence, current_occurrence)
    token = ENV['INSTAGRAM_TOKEN']
    tag = ENV['INSTAGRAM_TAG']
    url = "https://api.instagram.com/v1/tags/#{tag}/media/recent?access_token=#{token}"
    logger.info "hitting #{url}"
    response = HTTParty.get(url)
    body = ActiveSupport::JSON.decode(response.body)
    if body['data']
      body['data'].each do |object|
        if object['created_time'].to_f > last_occurrence
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
