class PhotosController < ApplicationController
  respond_to :json

  def index
    if params[:timestamp]
      timestamp = Time.zone.at(params[:timestamp].to_f)
      @photos = Photo.with_deleted.where('updated_at >= ?', timestamp).order(created_at: :asc)
    else
      @photos = Photo.all
    end

    respond_with(@photos)
  end
end
