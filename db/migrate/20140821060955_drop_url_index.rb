class DropUrlIndex < ActiveRecord::Migration
  def change
    remove_index :photos, :url
  end
end
