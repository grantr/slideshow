class PhotosController < ApplicationController
  respond_to :json

  def index
    if params[:timestamp]
      timestamp = Time.zone.at(params[:timestamp].to_f)
      @photos = Photo.where('created_at >= ?', timestamp)
    else
      @photos = Photo.all
    end

    respond_with(@photos)
  end
end
