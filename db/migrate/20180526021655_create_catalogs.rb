class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.integer :uniq_id
      t.string :name, null: false, default: ''
      t.integer :sort, default: 0
      t.boolean :opened, default: true
      t.timestamps null: false
    end
    add_index :catalogs, :uniq_id, unique: true
    
  end
end
