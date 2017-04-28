module BeachApiCore
  class InvitationRole < ApplicationRecord
    belongs_to :role
    belongs_to :invitation

    validates :role, :invitation, presence: true
  end
end
