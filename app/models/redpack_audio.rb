class RedpackAudio < ActiveRecord::Base
  validates :name, :file, presence: true
  
  mount_uploader :file, AudioUploader
  
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
  
  before_save :remove_blank_value_for_array
  def remove_blank_value_for_array
    self.tags = self.tags.compact.reject(&:blank?)
  end
  
  validate :required_tags
  def required_tags
    if tags.empty?
      errors.add(:base, '至少选择一个分类')
      return
    end
  end
  
  def tag_names
    @tag_names = Catalog.where(uniq_id: self.tags).pluck(:name)
    @tag_names.join(',')
  end
  
  def owner
    @owner ||= User.find_by(uid: self.owner_id)
  end
  
end
