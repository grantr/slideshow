# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Getting photos from snapable..."
# SnapableWorker.new.perform
puts "Getting photos from instagram..."
# InstagramWorker.new.perform
puts "Getting photos from instagram photobooth..."
# InstagramPhotoboothWorker.new.perform
puts "Getting photos from dropbox..."
# DropboxUploadCamWorker.new.perform
DropboxCameraUploadWorker.perform
DropboxSeedWorker.perform
