module BeachApiCore
  class RewardSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:current_user)
    attributes :id, :achievement_id, :confirmed, :status,
               :created_at
    attribute :gift_uuid, if: :gift_exist?
    attribute :shortlink, if: :shortlink_exist?
    attribute :giftbit_brand, if: :check_on_gift?

    def reward_to_type
      object.reward_to_type.gsub("BeachApiCore::", "")
    end

    def gift_exist?
      !object.gift_uuid.blank?
    end

    def shortlink_exist?
      !object.shortlink.blank?
    end

    def check_on_gift?
      object.achievement.mode_type == "BeachApiCore::GiftbitConfig" && !object.giftbit_brand_id.blank?
    end
  end
end