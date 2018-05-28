class AddVipExpiredAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vip_expired_at, :datetime
  end
end
