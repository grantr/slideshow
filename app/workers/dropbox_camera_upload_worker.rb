class DropboxCameraUploadWorker < ScheduledWorker

    recurrence backfill: false do
      secondly(30)
    end

  def perform(last_occurrence=0, current_occurrence=Time.now.to_f)
    return unless super
    token = ENV['DROPBOX_TOKEN']
    client = DropboxClient.new(token)

    logger.info "hitting dropbox metadata"
    path = "/Camera Uploads"
    contents = client.metadata(path)['contents']

    contents.each do |file|
      logger.info "checking #{file['client_mtime']}"
      if Time.parse(file['client_mtime'] || file['modified']).to_f >= (last_occurrence - 60)
        begin
          photo = Photo.new(url: "file://#{file['path']}", source: 'dropbox')
          photo.image = client.get_file(file['path'])
          photo.image_name = Pathname.new(file['path']).basename.to_s
          if photo.save
            logger.info "Created dropbox photo #{photo.inspect}"
          end
        rescue ActiveRecord::RecordNotUnique
          # we created this one already, no big deal
        end
      end
    end
  end
end
