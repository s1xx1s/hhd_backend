class AddViewCountToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :view_count, :integer, default: 0
  end
end
