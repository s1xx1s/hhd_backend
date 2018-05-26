class ChangeSomeColumnsForRedpacks < ActiveRecord::Migration
  def change
    rename_column :redpacks, :user_id, :owner_id
    remove_column :redpacks, :bg_audio
    add_column :redpacks, :audio_id, :integer
    add_index :redpacks, :audio_id
  end
end
