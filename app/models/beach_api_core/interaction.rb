module BeachApiCore
  class Interaction < ApplicationRecord
    include BeachApiCore::Concerns::AssetConcern

    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :keeper, polymorphic: true
    has_many :interaction_attributes, inverse_of: :interaction, class_name: 'BeachApiCore::InteractionAttribute', dependent: :destroy
    has_many :attachments, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy

    accepts_nested_attributes_for :interaction_attributes
    accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :file_blank?

    validates :user, :keeper, :kind, presence: true
  end
end
