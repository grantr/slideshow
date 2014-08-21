class DropboxController < ApplicationController

  def show
    render plain: params['challenge']
  end

  def create
    head :ok
  end
end
