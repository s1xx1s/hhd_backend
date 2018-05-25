class RedpackSendLog < ActiveRecord::Base
  
  before_create :generate_uniq_id
  def generate_uniq_id
    begin
      self.uniq_id = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  after_create :change_sent_stat
  def change_sent_stat
    redpack.change_sent_stat!(self.money) if redpack.present?
  end
  
  def user
    @user ||= User.find_by(uid: self.user_id)
  end
  
  def redpack
    @redpack ||= Redpack.find_by(uniq_id: self.redpack_id)
  end
  
  def redpack_owner
    redpack.try(:user)
  end
  
  def format_money
    '%.2f' % (self.money / 100.0)
  end
end
