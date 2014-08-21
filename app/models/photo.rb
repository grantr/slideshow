class Photo < ActiveRecord::Base
  extend Dragonfly::Model
  dragonfly_accessor :image
  
  validates_presence_of :url
  validates_uniqueness_of :url
end
