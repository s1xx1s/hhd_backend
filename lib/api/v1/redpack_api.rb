module API
  module V1
    class RedPacketsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :redpack, desc: '红包相关接口' do
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
          
          loc = nil
          if params[:loc]
            loc = params[:loc].gsub(',', ' ')
            loc = "POINT(#{loc})"
          end
          
          log = RedpackSendLog.create!(user_id: user.uid, redpack_id: hb.uniq_id, money: hb.random_money, ip: client_ip, location: loc)
          
          { code: 0, message: 'ok', data: { id: log.uniq_id } }
          
        end # end post grab
        
      end # end resource
      
    end
  end
end