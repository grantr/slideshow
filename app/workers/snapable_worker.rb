class SnapableWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { secondly(30) }

  def perform(last_occurrence, current_occurrence)
    logger.debug "ZOMG performing!"
    url = "https://snapable.com/ajax/get_photos/#{ENV['EVENT_ID']}"
    if last_occurrence > 0
      url << "/#{last_occurrence}"
    end
    response = HTTParty.get(url, headers: {"X-Requested-With" => "XMLHttpRequest"})
    body = ActiveSupport::JSON.decode(response)
    body['objects'].each do |object|
      photo_id = object['resource_uri'].split('/').last
      photo_url = "https://snapable.com/p/get/#{photo_id}/orig"
      photo_caption = object['caption']

      begin
        photo = Photo.new(url: photo_url, caption: photo_caption)
        if photo.save
          logger.info "Created photo: #{photo.inspect}"
        end
      rescue ActiveRecord::RecordNotUnique
        # we created this one already, no big deal
      end
    end
  end
end
