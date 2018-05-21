class CreateRedpackThemes < ActiveRecord::Migration
  def change
    create_table :redpack_themes do |t|
      t.integer :uniq_id
      t.string :name
      t.string :cover, null: false # 红包壳子封面
      t.string :take_audio
      t.string :result_audio

      t.timestamps null: false
    end
    add_index :redpack_themes, :uniq_id, unique: true
  end
end
