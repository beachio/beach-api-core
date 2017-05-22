module BeachApiCore
  class Membership < ApplicationRecord
    validates :group_id, uniqueness: { scope: %i(group_type member_id member_type) }
    validates :member, :group, presence: true

    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true
  end
end
