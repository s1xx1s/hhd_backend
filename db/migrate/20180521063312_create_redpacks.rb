class CreateRedpacks < ActiveRecord::Migration
  def change
    create_table :redpacks do |t|
      t.integer :uniq_id
      t.string :subject # 如果设置，默认为，从配置中读取恭喜发财大吉大利
      t.integer :merch_id, null: false
      t.integer :_type, default: 0 # 0表示拼手气红包；1表示普通红包
      t.integer :total_money, null: false # 红包总金额
      t.integer :sent_money, default: 0   # 已发红包金额
      t.integer :total_count, null: false # 红包个数
      t.integer :sent_count, default: 0   # 已发红包数
      t.integer :min_value # 红包最小值
      t.integer :use_type, null: false # 红包使用类型，1 现金红包 2 非现金红包
      t.integer :theme_id, null: false # 红包主题
      t.boolean :opened, default: true

      t.timestamps null: false
    end
    add_index :redpacks, :uniq_id, unique: true
    add_index :redpacks, :merch_id
    add_index :redpacks, :theme_id
  end
end
