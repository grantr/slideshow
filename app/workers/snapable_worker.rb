class SnapableWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence backfill: false do
    secondly(30)
  end

  def perform(last_occurrence, current_occurrence)
    url = "https://snapable.com/ajax/get_photos/#{ENV['EVENT_ID']}"
    if last_occurrence > 0
      url << "/#{last_occurrence-60}"
    end
    logger.info "hitting #{url}"
    response = HTTParty.get(url, headers: {"X-Requested-With" => "XMLHttpRequest"})
    body = ActiveSupport::JSON.decode(response.body)
    body['objects'].each do |object|
      photo_id = object['resource_uri'].split('/').last
      photo_url = "https://snapable.com/p/get/#{photo_id}/orig"
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
