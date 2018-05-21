class Redpack < ActiveRecord::Base
  validates :merch_id, :total_money, :sent_count, :use_type, :theme_id, presence: true
  
  before_create :generate_unique_id
  def generate_unique_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def merchant
    @merchant ||= Merchant.find_by(uniq_id: self.merch_id)
  end
  
end
