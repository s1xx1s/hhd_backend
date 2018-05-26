class CreateRedpackAudios < ActiveRecord::Migration
  def change
    create_table :redpack_audios do |t|
      t.integer :uniq_id
      t.integer :owner_id
      t.string :name
      t.string :file
      t.integer :tags, array: true, default: []
      t.integer :sort, default: 0
      t.boolean :opened, default: true
      
      t.timestamps null: false
    end
    add_index :redpack_audios, :uniq_id, unique: true
    add_index :redpack_audios, :tags, using: 'gin'
    add_index :redpack_audios, :owner_id
  end
end
