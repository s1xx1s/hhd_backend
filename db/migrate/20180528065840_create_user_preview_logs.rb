class CreateUserPreviewLogs < ActiveRecord::Migration
  def change
    create_table :user_preview_logs do |t|
      t.string :uniq_id
      t.integer :user_id, null: false
      t.integer :theme_id
      t.string :subject
      t.integer :audio_id
      t.boolean :in_use, default: false # 是否使用了该预览创建红包
      
      t.timestamps null: false
    end
    add_index :user_preview_logs, :uniq_id, unique: true
    add_index :user_preview_logs, :user_id
    add_index :user_preview_logs, :theme_id
    add_index :user_preview_logs, :audio_id
  end
end
