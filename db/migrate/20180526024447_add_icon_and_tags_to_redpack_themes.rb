class AddIconAndTagsToRedpackThemes < ActiveRecord::Migration
  def change
    add_column :redpack_themes, :icon, :string
    add_column :redpack_themes, :tags, :integer, array: true, default: []
    rename_column :redpack_themes, :merch_id, :owner_id
    add_index :redpack_themes, :tags, using: 'gin'
  end
end
