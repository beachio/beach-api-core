module BeachApiCore
  class Entity < ApplicationRecord
    belongs_to :user, inverse_of: :entities

    validates :user, :uid, :kind, presence: true
    validates :kind, uniqueness: { scope: :uid }
  end
end
