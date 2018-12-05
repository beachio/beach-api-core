module BeachApiCore
  class Invite < ApplicationRecord
    belongs_to :application, class_name: 'Doorkeeper::Application'
    belongs_to :user, class_name: 'BeachApiCore::User'

    def reset_invites_count
      self.update_attribute(:quantity,  0)
    end
  end
end
