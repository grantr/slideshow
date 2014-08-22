class SnapableWorker < ScheduledWorker

    recurrence backfill: false do
      secondly(30)
    end

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    return unless super
    event_id = ENV['SNAPABLE_EVENT_ID']
    url = "https://snapable.com/ajax/get_photos/#{event_id}"
    if last_occurrence > 0
      url << "/#{last_occurrence-60}"
    end
    logger.info "hitting #{url}"
    response = HTTParty.get(url, headers: {"X-Requested-With" => "XMLHttpRequest"})
    logger.info "snapable response: #{response.code}"
    body = ActiveSupport::JSON.decode(response.body)
    body['objects'].each do |object|
      photo_id = object['resource_uri'].split('/').last
      # get the scaled version since it's rotated correctly
      photo_url = "https://snapable.com/p/get/#{photo_id}/640x640"
      photo_caption = object['caption']

      begin
        photo = Photo.new(url: photo_url, caption: photo_caption, source: 'snapable')
        photo.image_url = photo_url
        if photo.save
          logger.info "Created snapable photo: #{photo.inspect}"
        end
      rescue ActiveRecord::RecordNotUnique
        # we created this one already, no big deal
      end
    end
  end
end
