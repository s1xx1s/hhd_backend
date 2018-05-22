ActiveAdmin.register RedpackTheme do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :merch_id, :cover, :name, :qrcode_watermark_pos, :qrcode_watermark_config, :text_watermark_pos, :text_watermark_config, :opened, :sort
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
  selectable_column
  column '#', :id
  column 'ID', :uniq_id
  column :name
  column '红包封面' do |o|
    image_tag o.cover.url(:small)
  end
  column '所属商家' do |o|
    o.merchant.try(:name) || '--'
  end
  column '二维码位置/二维码设置' do |o|
    raw("#{o.qrcode_watermark_pos}<br>#{o.qrcode_watermark_config}")
  end
  column '文字水印位置/文字水印设置' do |o|
    raw("#{o.text_watermark_pos}<br>#{o.text_watermark_config}")
  end
  column :opened
  column 'at', :created_at
  
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :merch_id, as: :select, label: '所属商家', collection: Merchant.where(opened: true).map { |merch| [merch.name, merch.uniq_id] }
    f.input :cover
    f.input :name, placeholder: '模板名称'
    f.input :sort, label: '显示顺序', hint: '值越大显示越靠前'
    f.input :opened, label: '启用该模板'
  end
  
  f.inputs '红包二维码设置' do
    f.input :qrcode_watermark_pos, as: :select, label: '二维码位置', collection: RedpackTheme.watermark_pos_data,
      prompt: '-- 选择二维码位置 --', input_html: { style: 'width: 240px;' }
    f.input :qrcode_watermark_config, label: '二维码设置'
  end
  
  f.inputs '红包描述水印文字设置' do
    f.input :text_watermark_pos, as: :select, label: '文字水印位置', collection: RedpackTheme.watermark_pos_data,
      prompt: '-- 选择文字水印位置 --', input_html: { style: 'width: 240px;' }
    f.input :text_watermark_config, label: '文字水印设置'
  end
  
  actions
end

end
