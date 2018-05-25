class AddUserIdToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :user_id, :integer
    add_index :redpacks, :user_id
  end
end
