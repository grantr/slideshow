class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :caption, :created_at, :url, :deleted_at

  def url
    object.image.url
  end
end
