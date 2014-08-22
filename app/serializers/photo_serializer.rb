class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :caption, :created_at, :url, :deleted_at

  def created_at
    object.created_at.to_f
  end

  def url
    object.image.url
  end
end
