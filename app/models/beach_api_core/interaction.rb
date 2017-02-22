module BeachApiCore
  class Interaction < ApplicationRecord
    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :keeper, polymorphic: true

    validates :user, :keeper, :kind, presence: true
  end
end
