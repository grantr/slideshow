class AddUniqueIndexToPhotoChecksum < ActiveRecord::Migration
  def change
    add_index :photos, :checksum, unique: true
  end
end
