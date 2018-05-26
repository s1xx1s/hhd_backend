ActiveAdmin.register RedpackTheme do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :owner_id, :icon, :cover, :name, :qrcode_watermark_pos, :qrcode_watermark_config, :text_watermark_pos, :text_watermark_config, :opened, :sort, { tags: [] }

index do
  selectable_column
  column '#', :id
  column 'ID', :uniq_id
  column :name
  column '红包ICON' do |o|
    image_tag o.icon.url(:small)
  end
  column :tags do |o|
    o.tag_names
  end
  column '所有者' do |o|
    o.owner.try(:format_nickname) || '--'
  end
  column '二维码位置/二维码设置' do |o|
    raw("#{o.qrcode_watermark_pos}<br>#{o.qrcode_watermark_config}")
  end
  column '文字水印位置/文字水印设置' do |o|
    raw("#{o.text_watermark_pos}<br>#{o.text_watermark_config}")
  end
  column :sort
  column :opened
  column 'at', :created_at
  
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :icon
    f.input :cover
    f.input :tags, as: :check_boxes, label: '所属分类', collection: Catalog.where(opened: true).map { |a| [a.name, a.uniq_id] }, required: true
    f.input :owner_id, as: :select, label: '所属用户', collection: User.where(verified: true).map { |user| [user.format_nickname, user.uid] }
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
