module BeachApiCore
  class Membership < ApplicationRecord
    validates :group_id, uniqueness: { scope: [:group_type, :member_id, :member_type] }
    validates :member, :group, presence: true
    validate :member_can_join_only_one_organization

    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true

    private

    def member_can_join_only_one_organization
      errors.add(:member, 'can not join more than one organization') if member &&
          group.is_a?(BeachApiCore::Organisation) &&
          member.organisation.present? &&
          member.organisation != group
    end
  end
end
