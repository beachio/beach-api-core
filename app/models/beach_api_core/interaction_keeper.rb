module BeachApiCore
  class InteractionKeeper < ApplicationRecord
    belongs_to :interaction, class_name: 'BeachApiCore::Interaction', inverse_of: :interaction_keepers
    belongs_to :keeper, polymorphic: true

    validates :interaction, :keeper, presence: true
  end
end
