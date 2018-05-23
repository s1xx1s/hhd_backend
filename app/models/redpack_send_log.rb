class RedpackSendLog < ActiveRecord::Base
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
end
