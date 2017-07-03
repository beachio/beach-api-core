module BeachApiCore
  class InteractionAttribute < ApplicationRecord
    belongs_to :interaction, inverse_of: :interaction_attributes, class_name: 'BeachApiCore::Interaction', touch: true

    validates :interaction, presence: true, uniqueness: { scope: :key }
    validates :interaction, :key, presence: true

    acts_as_downcasable_on :key
    acts_as_strippable_on :key
  end
end
