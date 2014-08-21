class AddUrlIndex < ActiveRecord::Migration
  def change
    add_index :photos, :url, unique: true
  end
end
