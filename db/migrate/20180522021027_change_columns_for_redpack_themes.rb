class ChangeColumnsForRedpackThemes < ActiveRecord::Migration
  def change
    remove_column :redpack_themes, :take_audio
    remove_column :redpack_themes, :result_audio
    add_column :redpack_themes, :qrcode_watermark_pos, :string
    add_column :redpack_themes, :qrcode_watermark_config, :string
    add_column :redpack_themes, :text_watermark_pos, :string
    add_column :redpack_themes, :text_watermark_config, :string
  end
end
