ActiveAdmin.register RedpackTheme do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :merch_id, :cover, :name, :take_audio, :result_audio, :opened, :sort
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
    f.input :take_audio
    f.input :result_audio
    f.input :sort, label: '显示顺序', hint: '值越大显示越靠前'
    f.input :opened, label: '启用该模板'
  end
    
  actions
end

end
