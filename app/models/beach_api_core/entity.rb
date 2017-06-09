module BeachApiCore
  class Entity < ApplicationRecord
    belongs_to :user, inverse_of: :entities

    validates :user, :uid, :kind, presence: true
    validates :kind, uniqueness: { scope: :uid }

    def self.lookup_by_instance(instance)
      find_by(uid: instance.id, kind: instance.class.name)
    end
  end
end
