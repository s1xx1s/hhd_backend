class AddBgAudioToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :bg_audio, :string
  end
end
