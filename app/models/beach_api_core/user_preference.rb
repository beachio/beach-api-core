module BeachApiCore
  class UserPreference < ApplicationRecord
    belongs_to :user
    belongs_to :application, class_name: 'Doorkeeper::Application'

    validates :user, :application, :preferences, presence: true
  end
end
