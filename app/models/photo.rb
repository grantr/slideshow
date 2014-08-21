class Photo < ActiveRecord::Base
  extend Dragonfly::Model
  dragonfly_accessor :image

  validates_uniqueness_of :checksum

  acts_as_paranoid

  before_validation do
    self.checksum = Digest::MD5.hexdigest(image.data) if image
  end

end
