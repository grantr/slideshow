class InboxWorker
  include Sidekiq::Worker

  def perform(photo_json)
    photo = Photo.new(ActiveSupport::JSON.decode(photo_json))
    photo.save
  end
end
