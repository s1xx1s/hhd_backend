class AddSignToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :sign, :string, array: true, default: []
  end
end
