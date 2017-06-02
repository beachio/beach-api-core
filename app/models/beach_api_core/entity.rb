module BeachApiCore
  class Entity < ApplicationRecord
    belongs_to :user, inverse_of: :entities

    validates :user, :uid, :kind, presence: true
    validates :kind, uniqueness: { scope: :uid }

    def self.find_by_instance(instance)
      find_by(user: instance.user, uid: instance.id.to_s, kind: instance.class.to_s)
    end
  end
end
