module BeachApiCore
  class Interaction < ApplicationRecord
    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :keeper, polymorphic: true
    has_many :interaction_attributes, class_name: 'BeachApiCore::InteractionAttribute'
    has_many :attachments, class_name: 'BeachApiCore::Asset', as: :entity, inverse_of: :entity, dependent: :destroy

    accepts_nested_attributes_for :interaction_attributes

    validates :user, :keeper, :kind, presence: true
  end
end
