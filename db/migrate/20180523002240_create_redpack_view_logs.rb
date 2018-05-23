class CreateRedpackViewLogs < ActiveRecord::Migration
  def change
    create_table :redpack_view_logs do |t|
      # t.string :uniq_id
      t.integer :redpack_id, index: true
      t.integer :user_id, index: true
      t.string :ip
      t.st_point :location, geographic: true
      t.integer :from_type, default: 0 # 0表示来自ionic app端
      
      t.timestamps null: false
    end
    # add_index :redpack_view_logs, :uniq_id
    add_index :redpack_view_logs, :location, using: :gist
  end
end
