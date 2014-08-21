class InboxController < ApplicationController
  include Mandrill::Rails::WebHookProcessor

  def handle_inbound(event_payload)
    Rails.logger.info "Received payload: #{event_payload.inspect}"
    if attachments = event_payload.attachments.presence
      attachments.each do |attachment|
        url = "inbox://#{SecureRandom.uuid}.#{attachment.name}"
        photo = Photo.new(url: url, source: 'inbox')
        photo.image = attachment.decoded_content
        photo.image_name = attachment.name
        photo.save
      end
    end
  end
end
