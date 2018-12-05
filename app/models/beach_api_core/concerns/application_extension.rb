module BeachApiCore::Concerns::ApplicationExtension
  extend ActiveSupport::Concern
  include BeachApiCore::Concerns::KeeperRoles

  included do
    belongs_to :owner, polymorphic: true
    belongs_to :publisher, polymorphic: true
    has_many :capabilities, class_name: 'BeachApiCore::Capability', dependent: :destroy
    has_many :services, through: :capabilities, class_name: 'BeachApiCore::Service'
    has_many :organisations, class_name: 'BeachApiCore::Organisation', dependent: :destroy
    has_many :jobs, class_name: 'BeachApiCore::Job', dependent: :destroy
    has_many :webhooks, class_name: 'BeachApiCore::Webhook', dependent: :destroy
    has_many :owned_chats, class_name: 'BeachApiCore::Chat', as: :keeper, inverse_of: :keeper, dependent: :destroy
    has_many :mail_bodies, class_name: "BeachApiCore::MailBody", dependent: :destroy
    has_many :custom_views, class_name: "BeachApiCore::CustomView", dependent: :destroy
    has_many :scores, class_name: "BeachApiCore::Score", dependent: :destroy
    has_many :bots, class_name: "BeachApiCore::Bot"
    has_many :invites, class_name: "BeachApiCore::Invite", dependent: :destroy
    accepts_nested_attributes_for :services, allow_destroy: true
    accepts_nested_attributes_for :capabilities, allow_destroy: true
    accepts_nested_attributes_for :mail_bodies, allow_destroy: true
    accepts_nested_attributes_for :custom_views, allow_destroy: true
    attr_accessor :use_default_logo_image, :file, :use_default_application_logo, :application_file, :background_image_file, :use_default_background_image
    validate :css_hex_color
    after_validation :upload_file_to_s3, :upload_application_logo_to_s3, :upload_background_image_to_s3
    after_destroy :clear_s3
    def policy_class
      BeachApiCore::OAuthApplicationPolicy
    end

    IMAGE_EXTENSION = ["jpg", "jpeg", "png"]

    private

    def upload_file_to_s3
      if !empty_s3_credentials && use_default_logo_image != "1" && !file.nil?
        res = upload_image_file_to_s3(file, s3_file_path, "logo")
        self.logo_url = res[0]
        self.s3_file_path = res[1]
      elsif use_default_logo_image == "1" || empty_s3_credentials
        unless self.s3_file_path.nil? || self.s3_file_path.empty?
          unless empty_s3_credentials
            s3 = Aws::S3::Resource.new
            s3.bucket(ENV['AWS_BUCKET']).object(s3_file_path).delete
          end
        end
        self.logo_url = ""
        self.s3_file_path = ""
      end
    end

    def upload_application_logo_to_s3
      if !empty_s3_credentials && use_default_application_logo != "1" && !application_file.nil?
        res = upload_image_file_to_s3(application_file, application_logo_path, "application_logo")
        self.application_logo_url = res[0]
        self.application_logo_path = res[1]
      elsif use_default_application_logo == "1" || empty_s3_credentials
        unless self.application_logo_path.nil? || self.application_logo_path.empty?
          unless empty_s3_credentials
            s3 = Aws::S3::Resource.new
            s3.bucket(ENV['AWS_BUCKET']).object(application_logo_path).delete
          end
        end
        self.application_logo_url = ""
        self.application_logo_path = ""
      end
    end

    def upload_background_image_to_s3
      if !empty_s3_credentials && use_default_background_image != "1" && !background_image_file.nil?
        res = upload_image_file_to_s3(background_image_file, background_image_path, "background_image")
        self.background_image = res[0]
        self.background_image_path = res[1]
      elsif use_default_background_image == "1" || empty_s3_credentials
        unless self.background_image_path.empty? || self.background_image_path.nil?
          unless empty_s3_credentials
            s3 = Aws::S3::Resource.new
            s3.bucket(ENV['AWS_BUCKET']).object(background_image_path).delete
          end
        end
        self.background_image = ""
        self.background_image_path = ""
      end
    end

    def upload_image_file_to_s3(file, path, name)
      s3 = Aws::S3::Resource.new
      file_type = file.content_type.split("/").last
      s3.bucket(ENV['AWS_BUCKET']).object(path).delete unless path.empty? || path.nil?
      image_path = "#{self.name}/#{Time.now} #{name}.#{file_type}"
      obj = s3.bucket(ENV['AWS_BUCKET']).object(image_path)
      obj.upload_file(file.open, acl: 'public-read')
      [obj.public_url, image_path]
    end


    def clear_s3
      if !empty_s3_credentials
        s3 = Aws::S3::Resource.new
        s3.bucket(ENV['AWS_BUCKET']).object(s3_file_path).delete unless self.s3_file_path.empty? || self.s3_file_path.nil?
        s3.bucket(ENV['AWS_BUCKET']).object(application_logo_path).delete unless self.application_logo_path.empty? || self.application_logo_path.nil?
        s3.bucket(ENV['AWS_BUCKET']).object(background_image_path).delete unless self.background_image_path.empty? || self.background_image_path.nil?
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
