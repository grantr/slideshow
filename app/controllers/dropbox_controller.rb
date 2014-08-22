class DropboxController < ApplicationController
  protect_from_forgery except: :create

  def show
    render plain: params['challenge']
  end

  def create
    head :ok
  end
end
