class RedpackTheme < ActiveRecord::Base
  validates :cover, presence: true
  
  mount_uploader :cover, CoverImageUploader
  mount_uploader :take_audio, AudioUploader
  mount_uploader :result_audio, AudioUploader
  
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
  
end
