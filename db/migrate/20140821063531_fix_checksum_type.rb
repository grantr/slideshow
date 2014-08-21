class FixChecksumType < ActiveRecord::Migration
  def change
    change_column :photos, :checksum, :string
  end
end
