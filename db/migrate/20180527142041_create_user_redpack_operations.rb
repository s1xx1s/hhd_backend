class CreateUserRedpackOperations < ActiveRecord::Migration
  def change
    create_table :user_redpack_operations do |t|
      # t.integer :uniq_id
      t.integer :user_id, null: false
      t.integer :redpack_id, null: false
      t.string :action, null: false
      t.string :memo

      t.timestamps null: false
    end
    # add_index :user_redpack_operations, :uniq_id, unique: true
    add_index :user_redpack_operations, :user_id
    add_index :user_redpack_operations, :redpack_id
  end
end
