class InboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    if attachments = event_payload.attachments.presence
      attachments.each do |attachment|
        url = "file://#{SecureRandom.uuid}.#{attachment.name}"

        photo = Photo.new(url: url, source: 'inbox')
        photo.image = attachment.decoded_content
        photo.image_name = attachment.name
        InboxWorker.perform(photo.to_json)
      end
    end
  end
end
