module BeachApiCore
  class AchievementBrand < ActiveRecord::Base
    belongs_to :achievement, class_name: "BeachApiCore::Achievement"
    belongs_to :giftbit_brand, class_name: "BeachApiCore::GiftbitBrand"
  end
end
