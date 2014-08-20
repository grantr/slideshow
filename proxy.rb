#!/usr/bin/env ruby
require 'sinatra'
require 'httparty'

get '/' do
  erb 'slides.html'
end

get '/ajax/get_photos/:timestamp?' do
  url = "https://snapable.com/ajax/get_photos/#{ENV['EVENT_ID']}"
  if params[:timestamp]
    url << "/#{params[:timestamp]}"
  end
  response = HTTParty.get(url, headers: {"X-Requested-With" => "XMLHttpRequest"})
  [response.code, response.headers, response.body]
end
