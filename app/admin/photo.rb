ActiveAdmin.register Photo do

  index do
    column :id
    # column :image do |photo|
    #   photo.image.url("200x200").url
    # end
    column :url
    column :caption
    column :created_at
    column :image_uid
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
