#!/usr/bin/env ruby
require 'sinatra'
require 'httparty'

get "/ajax/get_photos/#{ENV['EVENT_ID']}/:timestamp?" do
  url = "https://snapable.com/ajax/get_photos/#{ENV['EVENT_ID']}"
  if params[:timestamp]
    url << "/#{params[:timestamp]}"
  end
  response = HTTParty.get(url, headers: {"X-Requested-With" => "XMLHttpRequest"})
  [response.code, response.headers, response.body]
end
