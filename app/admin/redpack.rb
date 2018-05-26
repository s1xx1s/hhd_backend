ActiveAdmin.register Redpack do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :_type, :money, :total_count, :min_money, :use_type, :subject, :theme_id, :audio_id, :opened, :owner_id, :sign_val

index do
  selectable_column
  column '#', :id
  column 'ID', :uniq_id
  column :subject
  column '所有者' do |o|
    # o.merchant.try(:name) || o.merchant.try(:uniq_id) || '--'
    o.user.try(:format_nickname) || '--'
  end
  column '红包预览' do |o|
    image_tag o.redpack_image_url
  end
  column '红包音效' do |o|
    o.audio.blank? ? '--' : raw("<audio src=\"#{o.audio.file.url}\" controls=\"controls\"></audio><p>#{o.audio.name}</p>")
  end
  column '总金额/总个数' do |o|
    raw("#{o.total_money / 100.0}<br>#{o.total_count}")
  end
  column '已发出金额/已发送个数' do |o|
    raw("#{o.sent_money / 100.0}<br>#{o.sent_count}")
  end
  column '红包类型' do |o|
    o._type == 0 ? '拼手气红包' : '普通红包'
  end
  column '红包使用类型' do |o|
    if o.use_type == 1
      '现金红包'
    elsif o.use_type == 2
      '非现金红包'
    else
      '--'
    end
    # if o.use_type == 1
    #   '微信现金红包'
    # elsif o.use_type == 2
    #   '支付宝现金红包'
    # elsif o.use_type == 3
    #   '非现金红包'
    # end
  end
  column :opened
  column 'at', :created_at
  
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :owner_id, as: :select, label: '所属用户', collection: User.where(verified: true).map { |u| [u.format_nickname, u.uid] }
    f.input :subject, placeholder: '一句话描述你的红包'
    if f.object.new_record?
    f.input :_type, as: :radio, collection: [['拼手气红包', 0], ['普通红包', 1]], required: true, 
      input_html: { onchange: 'Redpack.changeType(this)' }
    else
      f.input :_type, as: :radio, collection: [['拼手气红包', 0], ['普通红包', 1]], required: true, 
        input_html: { onchange: 'Redpack.changeType(this)', 
        data: { total_money: "#{f.object.try(:total_money)}", total_count: "#{f.object.try(:total_count)}" } }
    end
    f.input :use_type, as: :select, collection: [['现金红包', 1], ['非现金红包', 2]], required: true
      #data: { total_money: "#{f.object.try(:total_money)}", total_count: "#{f.object.try(:total_count)}" }
    if f.object.new_record? or f.object._type == 0
      f.input :money, as: :number, label: "总金额"
    else
      f.input :money, as: :number, label: "单个金额"
    end
    f.input :total_count, as: :number, label: '红包个数'
    f.input :theme_id, as: :select, label: '红包模板', collection: RedpackTheme.where(opened: true).map { |theme| [theme.name, theme.uniq_id] }
    f.input :audio_id, as: :select, label: '红包音效', collection: RedpackAudio.where(opened: true).map { |audio| [audio.name, audio.uniq_id] }
    f.input :opened
  end
  f.inputs "高级功能" do
    f.input :sign_val, label: '红包口令', placeholder: '多个口令请使用英文逗号(,)或者竖线(|)分隔', hint: '如果设置了红包口令，那么该红包就是一个口令红包了，用户需要输入口令拆红包'
    f.input :min_money, as: :number, label: '最小值', placeholder: '普通红包可不填，拼手气红包可以设置一个抢红包最低金额，默认为0.05元',
       hint: '拼手气红包可以指定一个最小值，如果不设置默认为0.05元；另：如果是发现金红包，那么该值最低不能小于1元'
  end
    
  actions
end

end
