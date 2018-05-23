class RedpackViewLog < ActiveRecord::Base
  after_create :add_view_count
  def add_view_count
    redpack.add_view_count if redpack.present?
  end
  
  def user
    @user ||= User.find_by(uid: self.user_id)
  end
  
  def redpack
    @redpack ||= Redpack.find_by(uniq_id: self.redpack_id)
  end
end
