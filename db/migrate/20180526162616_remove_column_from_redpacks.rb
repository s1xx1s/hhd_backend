class RemoveColumnFromRedpacks < ActiveRecord::Migration
  def change
    remove_index :redpacks, :merch_id
    remove_column :redpacks, :merch_id
  end
end
