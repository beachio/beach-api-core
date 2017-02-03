module BeachApiCore
  class Invitation < ApplicationRecord
    validates :email, :group, :user, presence: true

    belongs_to :user
    belongs_to :group, polymorphic: true
  end
end
