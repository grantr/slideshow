class PhotosController < ApplicationController
  respond_to :json
  
  def index
    if params[:timestamp]
      timestamp = Time.at(params[:timestamp])
      @photos = Photo.where('created_at >= ?', timestamp)
    else
      @photos = Photo.all
    end

    respond_with(@photos)
  end
end
