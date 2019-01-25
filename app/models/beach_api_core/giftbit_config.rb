module BeachApiCore
  class GiftbitConfig < ActiveRecord::Base
    belongs_to :application, class_name: "Doorkeeper::Application"
    has_many :giftbit_brands, class_name: "BeachApiCore::GiftbitBrand", dependent: :destroy
    has_many :achievements, class_name: "BeachApiCore::Achievement", as: :mode, dependent: :destroy
    has_many :rewards, through: :achievements
    accepts_nested_attributes_for :giftbit_brands, allow_destroy: true

    validates  :config_name, uniqueness: { scope: :application }
    validates :config_name, :application_id, presence: true
    validate :check_on_brands, :check_token

    def check_on_brands
      self.errors.add :giftbit_brands, 'There are should be one or more giftbit brands.' unless self.giftbit_brands.any?
    end

    def check_token
      unless self.giftbit_token.blank?
        body = BeachApiCore::GiftbitHelper.check_token(self.giftbit_token)
        self.errors.add :giftbit_token, "Wrong token." unless body["error"].nil?
      end
    end
  end
end
