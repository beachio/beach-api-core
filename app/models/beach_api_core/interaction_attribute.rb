module BeachApiCore
  class InteractionAttribute < ApplicationRecord
    include Concerns::Downcasable

    belongs_to :interaction, inverse_of: :interaction_attributes, class_name: 'BeachApiCore::Interaction'

    validates :key, presence: true, uniqueness: true

    acts_as_downcasable_on [:key]
  end
end
