# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

url = "https://snapable.com/ajax/get_photos/#{ENV['EVENT_ID']}"

puts "Getting photos from snapable..."

response = HTTParty.get(url, headers: {"X-Requested-With" => "XMLHttpRequest"})
body = ActiveSupport::JSON.decode(response.body)
body['objects'].each do |object|
  photo_id = object['resource_uri'].split('/').last
  photo_url = "https://snapable.com/p/get/#{photo_id}/orig"
  photo_caption = object['caption']

  begin
    photo = Photo.new(url: photo_url, caption: photo_caption)
    photo.image_url = photo_url

    if photo.save
      puts "Created photo #{photo.id} (#{photo.url})"
    end
  rescue ActiveRecord::RecordNotUnique
    # we created this one already, no big deal
  end
end
