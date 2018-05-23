ActiveAdmin.register RedpackSendLog do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
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
  column('ID', :uniq_id)
  column '红包', sortable: false do |o|
    o.redpack.blank? ? '' : link_to((o.redpack.subject || o.redpack.uniq_id), [:admin, o.redpack])
  end
  column '用户', sortable: false do |o|
    # o.user_id.blank? ? '' : link_to(o.user.format_nickname, [:admin, o.user])
    if o.user.blank?
      ''
    else
      link_to o.user.format_nickname, [:admin, o.user]
    end
  end
  column '红包收入' do |o|
    o.format_money
  end
  column 'IP', :ip, sortable: false
  column '位置坐标', sortable: false do |o|
    o.location
  end
  column 'at' do |o|
    o.created_at.strftime('%Y年%m月%d日 %H:%M:%S')
  end
  actions

end

end
