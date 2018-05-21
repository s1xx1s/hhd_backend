class Redpack < ActiveRecord::Base
  validates :merch_id, :total_money, :sent_count, :use_type, :theme_id, presence: true
  
  def merchant
    @merchant ||= Merchant.find_by(uniq_id: self.merch_id)
  end
  
end
