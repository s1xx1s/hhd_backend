class UserPreviewLog < ActiveRecord::Base
  before_create :generate_uniq_id
  def generate_uniq_id
    begin
      self.uniq_id = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def theme_url
    theme = RedpackTheme.find_by(uniq_id: self.theme_id)
    if theme.blank?
      theme = RedpackTheme.where(opened: true).first
    end
    
    qrcode_image_url = "#{SiteConfig.main_server}/qrcode?text=红包小屋"
    theme.watermark_image(qrcode_image_url, self.subject || SiteConfig.default_redpack_subject)
  end
  
  def audio_url
    if self.audio_id.blank?
      ''
    else
      @audio ||= RedpackAudio.find_by(uniq_id: self.audio_id)
      @audio.file.url
    end
  end
end
