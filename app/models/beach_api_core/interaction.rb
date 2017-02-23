module BeachApiCore
  class Interaction < ApplicationRecord
    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :keeper, polymorphic: true
    has_many :interaction_attributes, class_name: 'BeachApiCore::InteractionAttribute'

    accepts_nested_attributes_for :interaction_attributes

    validates :user, :keeper, :kind, presence: true
  end
end
