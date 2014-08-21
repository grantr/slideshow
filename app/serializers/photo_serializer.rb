class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :caption, :created_at, :url

  def url
    object.image.url
  end
end
