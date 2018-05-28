module API
  module V1
    class RedpackAPI < Grape::API
      
      helpers API::SharedParams
            
      #==========================================================================
      resource :redpack, desc: '红包相关接口' do
        desc "创建红包"
        params do
          requires :token, type: String, desc: '用户TOKEN'
          requires :money, type: Integer, desc: '红包总金额'
          requires :quantity, type: Integer, desc: '红包个数'
          requires :_type, type: Integer, desc: '红包类型，0表示拼手气，1表示普通红包'
          requires :use_type, type: Integer, desc: '红包使用类型；1表示现金红包，2表示非现金红包'
          optional :subject, type: String, desc: '红包主题'
          optional :sign, type: String, desc: '红包口令，多个口令使用英文逗号分隔（,）'
          optional :theme_id, type: Integer, desc: '红包模板'
          optional :audio_id, type: Integer, desc: '红包音效'
        end
        post :create do
          user = authenticate!
          
          if params[:money] <= 100
            return render_error(-4, '红包金额至少需要1元')
          end
          
          if params[:quantity] < 0
            return render_error(-4, '红包个数至少1个')
          end
          
          unless %w(0 1).include? params[:_type].to_s
            return render_error(-4, '不正确的红包类型参数，值为0或1')
          end
          
          unless %w(1 2).include? params[:use_type].to_s
            return render_error(-4, '不正确的红包用途参数，值为1或2')
          end
          
          if params[:use_type].to_i == 1 # 现金红包需要检查余额
            if user.balance < params[:money] 
              return render_error(1001, '余额不足，请先充值')
            end
          end
          
          # 红包模板
          if params[:theme_id]
            theme = RedpackTheme.find_by(uniq_id: params[:theme_id])
            if theme.blank?
              return render_error(4004, '红包模板不存在')
            end
          else
            # 取第一个默认模板
            theme = RedpackTheme.where(opened: true).first
          end
          
          # 红包音效
          if params[:audio_id]
            audio = RedpackAudio.find_by(uniq_id: params[:audio_id])
            if audio.blank?
              return render_error(4004, '红包音效不存在')
            end
          else
            audio = nil
          end
          
          sign = []
          if params[:sign]
            sign = params[:sign].split(',')
          end
          
          redpack = Redpack.create!(owner_id: user.uid, 
                                    total_money: params[:money], 
                                    total_count: params[:quantity],
                                    _type: params[:_type],
                                    use_type: params[:use_type],
                                    subject: params[:subject] || '恭喜发财，大吉大利',
                                    sign: sign,
                                    theme_id: theme.uniq_id,
                                    audio_id: audio.try(:uniq_id)
                                    )
          # 记录交易日志
          TradeLog.create!(user_id: user.uid, 
                           title: "发出一个#{redpack.is_cash? ? '现金' : '消费'}红包", 
                           money: redpack.total_money, 
                           action: "sent_hb",
                           tradeable_type: redpack.class,
                           tradeable_id: redpack.uniq_id
                           )
          
          render_json(redpack, API::V1::Entities::Redpack)
        end # end post create
        
        desc "红包浏览"
        params do
          optional :token, type: String, desc: '用户TOKEN'
          requires :id,    type: Integer,desc: '红包ID'
          optional :loc,   type: String,  desc: '经纬度，用英文逗号分隔，例如：104.213222,30.9088273'
        end
        post :view do 
          redpack = Redpack.find_by(uniq_id: self.params[:id])
          if redpack.blank?
            return render_error(4004, '红包不存在')
          end
          
          user = User.find_by(private_token: params[:token])
          user_id = user.try(:uid)
          
          loc = nil
          if params[:loc]
            loc = params[:loc].gsub(',', ' ')
            loc = "POINT(#{loc})"
          end
          
          RedpackViewLog.create!(user_id: user_id, redpack_id: redpack.uniq_id, ip: client_ip, location: loc)
          
          render_json_no_data
          
        end # end post view
        
        desc "获取红包详情"
        params do
          requires :token, type: String, desc: '用户TOKEN'
          requires :id,    type: Integer,desc: '红包ID'
          optional :loc,   type: String,  desc: '经纬度，用英文逗号分隔，例如：104.213222,30.9088273'
        end
        get :detail do 
          user = authenticate!
          
          redpack = Redpack.find_by(uniq_id: self.params[:id])
          if redpack.blank? or !redpack.opened
            return render_error(4004, '红包不存在')
          end
          
          # 保存红包浏览记录
          loc = nil
          if params[:loc]
            loc = params[:loc].gsub(',', ' ')
            loc = "POINT(#{loc})"
          end
          RedpackViewLog.create!(user_id: user.uid, redpack_id: redpack.uniq_id, ip: client_ip, location: loc)
          
          if !redpack.has_left?
            return render_error(4002, '下手太慢，红包已经被抢完了！')
          end
          
          if RedpackSendLog.where(user_id: user.uid, redpack_id: redpack.uniq_id).count > 0
            return render_error(4003, '您已经领过红包了！')
          end
          
          render_json(redpack, API::V1::Entities::Redpack)
          
        end # end post view
        
        desc "拆红包"
        params do
          requires :token, type: String,  desc: '用户TOKEN'
          requires :id,    type: Integer, desc: '红包ID'
          optional :sign,  type: String,  desc: '红包口令'
          optional :loc,   type: String,  desc: '经纬度，用英文逗号分隔，例如：104.213222,30.9088273'
        end
        post :take do
          user = authenticate!
          
          hb = Redpack.find_by(uniq_id: params[:id])
          if hb.blank? or !hb.opened
            return render_error(4004, '红包不存在')
          end
          
          if !hb.has_left?
            return render_error(4002, '下手太慢，红包已经被抢完了！')
          end
          
          if RedpackSendLog.where(user_id: user.uid, redpack_id: hb.uniq_id).count > 0
            return render_error(4003, '您已经领过红包了！')
          end
          
          # 口令红包
          if hb.sign.any?
            if params[:sign].blank? or not hb.sign.include?(params[:sign])
              return render_error(4000, '口令不正确')
            end
          end
          
          random_money = hb.random_money
          if random_money <= 0
            return render_error(4002, '下手太慢，红包已经被抢完了！')
          end
          
          loc = nil
          if params[:loc]
            loc = params[:loc].gsub(',', ' ')
            loc = "POINT(#{loc})"
          end
          
          log = RedpackSendLog.create!(user_id: user.uid, redpack_id: hb.uniq_id, money: random_money, ip: client_ip, location: loc)
          
          # { code: 0, message: 'ok', data: { id: log.uniq_id } }
          render_json(log, API::V1::Entities::RedpackSendLog)
          
        end # end post take
        
        desc "打开、关闭红包"
        params do
          requires :token, type: String,  desc: '用户TOKEN'
          requires :id,    type: Integer, desc: '红包ID'
          requires :action,type: String,  desc: '值为：open,close之一'
        end
        post '/:action' do
          user = authenticate!
          
          hb = Redpack.find_by(uniq_id: params[:id])
          if hb.blank?
            return render_error(4004, '红包不存在')
          end
          
          unless %w(open close).include? params[:action]
            return render_error(-1, 'action参数不正确，值为open或close')
          end
          
          error_msg = user.send("#{params[:action]}_redpack".to_sym,hb)
          if error_msg.blank?
            render_json_no_data
          else
            render_error(5001, error_msg)
          end
          
        end # end post open or close
        
        desc "编辑红包"
        params do
          requires :token, type: String,  desc: '用户TOKEN'
          requires :id,    type: Integer, desc: '红包ID'
          optional :subject, type: String, desc: '红包留言'
          optional :sign, type: String, desc: '红包口令'
          optional :theme_id,    type: Integer, desc: '红包模板'
          optional :audio_id,    type: Integer, desc: '红包音效'
        end
        post :update do
          user = authenticate!
          
          hb = Redpack.find_by(uniq_id: params[:id])
          if hb.blank?
            return render_error(4004, '红包不存在')
          end
          
          if params[:subject].blank? and 
             params[:sign].blank? and 
             params[:theme_id].blank? and 
             params[:audio_id].blank?
            return render_error(-1, '至少需要提交一个修改字段')
          end
          
          old_value = "#{hb.subject}#{hb.sign.join(',')}#{hb.theme_id}#{hb.audio_id}"
          new_value = "#{params[:subject]}#{params[:sign]}#{params[:theme_id]}#{params[:audio_id]}"
          
          if old_value == new_value
            render_json(hb, API::V1::Entities::SimpleRedpack)
          else
            # 需要更新红包
            hb.subject = params[:subject]
            
            if params[:sign]
              hb.sign = params[:sign].split(',')
            end
            
            # 红包模板
            if params[:theme_id]
              theme = RedpackTheme.find_by(uniq_id: params[:theme_id])
              if theme.blank?
                return render_error(4004, '红包模板不存在')
              end
              
              hb.theme_id = theme.uniq_id
            end
            
            # 红包音效
            if params[:audio_id]
              audio = RedpackAudio.find_by(uniq_id: params[:audio_id])
              if audio.blank?
                return render_error(4004, '红包音效不存在')
              end
              
              hb.audio_id = audio.uniq_id
            end
            
            hb.save!
            # 记录用户红包操作日志
            UserRedpackOperation.create!(user_id: user.uid, redpack_id: hb.uniq_id, action: 'edit_hb')
            
            render_json(hb, API::V1::Entities::SimpleRedpack)
          end
          
        end # end post update
                
      end # end resource
      
    end
  end
end