module BeachApiCore::Concerns::ApplicationExtension
  extend ActiveSupport::Concern
  include BeachApiCore::Concerns::KeeperRoles

  included do
    belongs_to :owner, polymorphic: true
    has_many :capabilities, class_name: 'BeachApiCore::Capability', dependent: :destroy
    has_many :services, through: :capabilities, class_name: 'BeachApiCore::Service'
    has_many :organisations, class_name: 'BeachApiCore::Organisation', dependent: :destroy
    has_many :jobs, class_name: 'BeachApiCore::Job', dependent: :destroy
    has_many :webhooks, class_name: 'BeachApiCore::Webhook', dependent: :destroy
    has_many :owned_chats, class_name: 'BeachApiCore::Chat', as: :keeper, inverse_of: :keeper, dependent: :destroy
    has_many :mail_bodies, class_name: "BeachApiCore::MailBody", dependent: :destroy
    has_many :bots, class_name: "BeachApiCore::Bot"
    accepts_nested_attributes_for :services, allow_destroy: true
    accepts_nested_attributes_for :capabilities, allow_destroy: true
    accepts_nested_attributes_for :mail_bodies, allow_destroy: true
    attr_accessor :use_default_logo_image, :file
    validate :css_hex_color
    after_validation :upload_file_to_s3
    after_destroy :clear_s3
    def policy_class
      BeachApiCore::OAuthApplicationPolicy
    end

    IMAGE_EXTENSION = ["jpg", "jpeg", "png"]

    private

    def upload_file_to_s3
      if !empty_s3_credentials && use_default_logo_image != "1" && !file.nil?
        s3 = Aws::S3::Resource.new
        file_type = self.file.content_type.split("/").last
        s3.bucket(ENV['AWS_BUCKET']).object(s3_file_path).delete unless self.s3_file_path.empty? || self.s3_file_path.nil?
        self.s3_file_path = "#{self.name}/#{Time.now} logo.#{file_type}"
        obj = s3.bucket(ENV['AWS_BUCKET']).object(s3_file_path)
        obj.upload_file(file.open, acl: 'public-read')
        self.logo_url = obj.public_url
      elsif empty_s3_credentials && use_default_logo_image == "1"
        unless self.s3_file_path.nil? || self.s3_file_path.empty?
          if !empty_s3_credentials
            s3 = Aws::S3::Resource.new
            s3.bucket(ENV['AWS_BUCKET']).object(s3_file_path).delete
          end
        end
        self.logo_url = ""
        self.s3_file_path = ""
      end
    end


    def clear_s3
      if !empty_s3_credentials
        s3 = Aws::S3::Resource.new
        s3.bucket(ENV['AWS_BUCKET']).object(s3_file_path).delete unless self.s3_file_path.empty? || self.s3_file_path.nil?
      end
    end

    def css_hex_color
      self.errors.add :mail_type_band_color, "must be a valid CSS hex color code" if (!self.mail_type_band_color.nil? && !self.mail_type_band_color.empty?) && self.mail_type_band_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.errors.add :mail_type_band_text_color, "must be a valid CSS hex color code" if (!self.mail_type_band_text_color.nil? && !self.mail_type_band_text_color.empty?) && self.mail_type_band_text_color.match(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i).nil?
      self.mail_type_band_color = "#ff8000" if self.mail_type_band_color.nil? || self.mail_type_band_color.empty?
      self.mail_type_band_text_color = "#FFFFFF" if self.mail_type_band_text_color.nil? || self.mail_type_band_text_color.empty?
      self.errors.add :file, "You can use only following extensions: #{IMAGE_EXTENSION}" if !self.file.nil? && !IMAGE_EXTENSION.include?(self.file.content_type.split("/").last)
    end

    def empty_s3_credentials
       ENV['AWS_BUCKET'].nil? || ENV['AWS_BUCKET'].empty? ||
           ENV['AWS_ACCESS_KEY_ID'].nil? || ENV['AWS_ACCESS_KEY_ID'].empty? ||
           ENV['AWS_SECRET_ACCESS_KEY'].nil? || ENV['AWS_SECRET_ACCESS_KEY'].empty? ||
           ENV['S3_REGION'].nil? || ENV['S3_REGION'].empty?
    end
  end
end
