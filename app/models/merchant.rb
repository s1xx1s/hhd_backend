class Merchant < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  
  before_create :generate_id_and_private_token
  def generate_id_and_private_token
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
    self.private_token = SecureRandom.uuid.gsub('-', '')
  end
  
end
