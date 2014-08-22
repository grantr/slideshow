ActiveAdmin.register Photo do

  batch_action :rotate_right do |ids|
    Photo.find(ids).each do |photo|
      photo.image.rotate!(90)
      photo.save
    end
    redirect_to collection_path, alert: "rotated right"
  end

  batch_action :rotate_left do |ids|
    Photo.find(ids).each do |photo|
      photo.image.rotate!(-90)
      photo.save
    end
    redirect_to collection_path, alert: "rotated left"
  end

  index do |photo|
    selectable_column
    column do|photo|
      link_to image_tag(photo.image.thumb('200x200').url), admin_photo_path(photo)
    end
    # link_to image_tag(photo.image.thumb('200x200').url), admin_photo_path(photo)
  end

  show do
    image_tag(photo.image.url)
  end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end


end
