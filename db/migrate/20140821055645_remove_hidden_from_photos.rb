class RemoveHiddenFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :hidden
  end
end
