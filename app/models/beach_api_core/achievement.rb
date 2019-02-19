module BeachApiCore
  class Achievement < ActiveRecord::Base
    belongs_to :application, class_name: "Doorkeeper::Application"
    belongs_to :mode, polymorphic: true
    has_many :achievement_brands, class_name: "BeachApiCore::AchievementBrand", dependent: :destroy
    has_many :giftbit_brands, :through => :achievement_brands
    has_many :rewards, class_name: "BeachApiCore::Reward", dependent: :destroy

    attr_readonly :points_required, :mode_type, :mode_id, :application_id
    validates :achievement_name, :application_id, :points_required,
              :max_rewards, :reward_expiry, :available_for, presence: true
    attr_accessor :use_all_brands
    validates  :achievement_name, uniqueness: { scope: :application }
    validate :check_on_webhook_exist
    validate :check_mode_type, on: [:create]
    validate :check_brands, :check_available_for
    scope :giftbit, -> { where(mode_type: 'BeachApiCore::GiftbitConfig').pluck(:id) }
    enum max_rewards: { "1 per day" => 0,
                        "1 per week" => 1,
                        "1 per month" => 2,
                        "unlimited" => 3
    }

    enum available_for: {
        "users" => 0,
        "devices" => 1,
        "users and devices" => 2
    }

    def check_mode_type
      self.errors.add :mode_type, "Wrong mode" if self.mode.blank? || !["BeachApiCore::GiftbitConfig", "BeachApiCore::WebhookConfig"].include?(self.mode_type) || self.mode.application_id != self.application_id
    end

    def check_brands
      brands = self.giftbit_brands.map {|brand| brand.id}
      self.errors.add :giftbit_brands, 'Wrong brands' if self.mode_type == "BeachApiCore::GiftbitConfig" && !use_all_config_brands && (brands.blank? || !(brands - self.mode.giftbit_brands.pluck(:id)).empty?)
    end

    def check_available_for
      self.errors.add :available_for if self.mode_type == "BeachApiCore::WebhookConfig" && !["users", "devices"].include?(self.available_for)
    end

    def check_on_webhook_exist
      self.errors.add :mode, "There is already an achievement with a webhook reward type for this application and available for #{self.available_for}." if self.mode_type == "BeachApiCore::WebhookConfig" && !BeachApiCore::Achievement.where(:mode_type => "BeachApiCore::WebhookConfig", :application_id => self.application_id, :available_for => self.available_for).
                                                                                                                           where.not(id: self.id).empty?
    end
  end
end
