class AddChecksumToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :checksum, :boolean
  end
end
