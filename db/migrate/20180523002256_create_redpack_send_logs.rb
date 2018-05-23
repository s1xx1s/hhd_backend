class CreateRedpackSendLogs < ActiveRecord::Migration
  def change
    create_table :redpack_send_logs do |t|
      t.string :uniq_id
      t.integer :user_id, index: true
      t.integer :redpack_id, index: true
      t.integer :money, null: false
      t.string :ip
      t.st_point :location, geographic: true
      t.timestamps null: false
    end
    add_index :redpack_send_logs, :uniq_id, unique: true
    add_index :redpack_send_logs, :location, using: :gist
    add_index :redpack_send_logs, [:user_id, :redpack_id], unique: true
  end
end
