class CreateRedpackConsumes < ActiveRecord::Migration
  def change
    create_table :redpack_consumes do |t|
      t.string :uniq_id
      t.integer :money, null: false
      t.string :send_log_id, null: false
      t.integer :redpack_id
      t.integer :user_id,  null: false
      t.integer :owner_id, null: false

      t.timestamps null: false
    end
    add_index :redpack_consumes, :uniq_id, unique: true
    add_index :redpack_consumes, :send_log_id
    add_index :redpack_consumes, :redpack_id
    add_index :redpack_consumes, :user_id
    add_index :redpack_consumes, :owner_id
  end
end
