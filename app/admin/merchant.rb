ActiveAdmin.register Merchant do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :avatar, :name, :mobile, :_type, :opened
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form do |f|
  f.semantic_errors
  f.inputs do
    f.input :avatar
    f.input :name
    f.input :mobile
    f.input :_type, as: :select, label: '商家类型', collection: [['普通用户', 0], ['个体户', 1], ['企业', 2]]
    f.input :opened, label: '账号启用'
  end
  actions
end

end
