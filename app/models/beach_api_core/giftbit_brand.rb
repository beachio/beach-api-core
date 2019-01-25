module BeachApiCore
  class GiftbitBrand < ActiveRecord::Base
    belongs_to :giftbit_config, class_name: "BeachApiCore::GiftbitConfig"
    has_many :achievement_brands, class_name: "BeachApiCore::AchievementBrand"
    has_many :achievements, :through => :achievement_brands, dependent: :destroy
    has_many :rewards, class_name: "BeachApiCore::Reward", dependent: :destroy
    validates :brand_code, :amount,  :gift_name, presence: true
    validates :email_body, :email_subject, presence: true, if: -> {giftbit_email_template.nil? || giftbit_email_template.empty?}
    validates  :gift_name, uniqueness: { scope: :giftbit_config }
    validate :check_brand_amount

    def check_brand_amount
      return unless errors.blank?
      api_key = self.giftbit_config.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : self.giftbit_config.giftbit_token
      result = BeachApiCore::GiftbitHelper.get_brand_amounts(api_key, self.brand_code)
      if result.blank?
        self.errors.add :brand_code, "Wrong brand code"
      else
        if result['allowed_prices_in_cents'].blank?
          self.errors.add :amount, "Wrong amount. For #{self.brand_code} minimum is: #{result['min_price_in_cents']}. Maximum: #{result['max_price_in_cents']}" if self.amount < result['min_price_in_cents'] || self.amount > result['max_price_in_cents']
        else
          self.errors.add :amount, "Wrong amount. For #{self.brand_code} allowed amount is: #{result['allowed_prices_in_cents'].join(", ")}" unless result['allowed_prices_in_cents'].include?(self.amount)
        end
      end
    end

  end
end
