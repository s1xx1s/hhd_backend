class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.integer :uniq_id
      t.string :avatar
      t.string :name
      t.string :mobile
      t.integer :balance, default: 0
      t.integer :_type, default: 0 # 0 表示普通用户；1 表示个体工商户 2 表示企业用户
      t.boolean :opened, default: true
      t.string :private_token

      t.timestamps null: false
    end
    add_index :merchants, :uniq_id, unique: true
    add_index :merchants, :private_token, unique: true
  end
end
