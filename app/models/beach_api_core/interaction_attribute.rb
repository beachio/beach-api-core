module BeachApiCore
  class InteractionAttribute < ApplicationRecord
    belongs_to :interaction, class_name: 'BeachApiCore::Interaction'

    validates :key, presence: true
  end
end
