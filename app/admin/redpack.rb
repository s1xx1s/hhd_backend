ActiveAdmin.register Redpack do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :_type, :money, :total_count, :min_money, :use_type, :subject, :theme_id, :opened, :merch_id
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
    f.input :merch_id, as: :select, label: '所属商家', collection: Merchant.where(opened: true).map { |merch| [merch.name, merch.uniq_id] }
    f.input :subject, placeholder: '一句话描述你的红包'
    if f.object.new_record?
    f.input :_type, as: :radio, collection: [['拼手气红包', 0], ['普通红包', 1]], required: true, 
      input_html: { onchange: 'Redpack.changeType(this)' }
    else
      f.input :_type, as: :radio, collection: [['拼手气红包', 0], ['普通红包', 1]], required: true, 
        input_html: { onchange: 'Redpack.changeType(this)', 
        data: { total_money: "#{f.object.try(:total_money)}", total_count: "#{f.object.try(:total_count)}" } }
    end
    f.input :use_type, as: :select, collection: [['微信现金红包', 1], ['支付宝红包', 2], ['非现金红包', 3]], required: true
      #data: { total_money: "#{f.object.try(:total_money)}", total_count: "#{f.object.try(:total_count)}" }
    if f.object.new_record? or f.object._type == 0
      f.input :money, as: :number, label: "总金额"
    else
      f.input :money, as: :number, label: "单个金额"
    end
    f.input :total_count, as: :number, label: '红包个数'
    f.input :theme_id, as: :select, label: '红包模板', collection: RedpackTheme.where(opened: true).map { |theme| [theme.name, theme.uniq_id] }
    f.input :min_money, as: :number, label: '最小值', placeholder: '普通红包可不填，拼手气红包可以设置一个抢红包最低金额，默认为0.05元',
       hint: '拼手气红包可以指定一个最小值，如果不设置默认为0.05元；另：如果是发现金红包，那么该值最低不能小于1元'
    f.input :opened
  end
    
  actions
end

end
