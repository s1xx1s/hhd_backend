class AddSomeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance, :integer, default: 0   # 余额
    add_column :users, :earn, :integer, default: 0      # 抢到的现金红包金额
    add_column :users, :pay_money, :integer, default: 0 # 抢到的非现金红包金额
    add_column :users, :sent_hb_count, :integer, default: 0 # 发红包总数
    add_column :users, :take_hb_count, :integer, default: 0 # 抢红包总数
  end
end
