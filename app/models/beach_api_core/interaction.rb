module BeachApiCore
  class Interaction < ApplicationRecord
    include BeachApiCore::Concerns::AssetConcern

    belongs_to :user, class_name: 'BeachApiCore::User'
    has_many :interaction_attributes,
             inverse_of: :interaction,
             class_name: 'BeachApiCore::InteractionAttribute',
             dependent: :destroy
    has_many :assets, as: :entity, inverse_of: :entity, dependent: :destroy
    has_many :interaction_keepers,
             class_name: 'BeachApiCore::InteractionKeeper',
             inverse_of: :interaction,
             dependent: :destroy

    accepts_nested_attributes_for :interaction_attributes, allow_destroy: true
    accepts_nested_attributes_for :interaction_keepers, allow_destroy: true
    accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :file_blank?

    validates :user, :interaction_keepers, :kind, presence: true
    validate :check_uniqueness_of_attributes_keys, on: %i(create update)

    private

    def check_uniqueness_of_attributes_keys
      return if interaction_attributes.map(&:key).uniq.size == interaction_attributes.size
      errors.add(:interaction_attributes, 'can not have duplicate keys')
    end
  end
end
