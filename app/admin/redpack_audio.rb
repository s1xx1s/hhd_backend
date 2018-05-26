ActiveAdmin.register RedpackAudio do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :file, :sort, :opened, :owner_id, { tags: [] }
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :name
    f.input :file
    f.input :tags, as: :check_boxes, label: '所属分类', collection: Catalog.where(opened: true).map { |a| [a.name, a.uniq_id] }, required: true
    f.input :owner_id, as: :select, label: '所属用户', collection: User.where(verified: true).map { |user| [user.format_nickname, user.uid] }
    f.input :sort, label: '显示顺序', hint: '值越大显示越靠前'
    f.input :opened, label: '启用该模板'
  end
  
  actions
  
end

end
