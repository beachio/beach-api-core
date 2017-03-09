module BeachApiCore
  class InteractionAttribute < ApplicationRecord
    belongs_to :interaction, inverse_of: :interaction_attributes, class_name: 'BeachApiCore::Interaction', autosave: true

    validates :key, presence: true
  end
end
