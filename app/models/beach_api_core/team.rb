module BeachApiCore
  class Team < ApplicationRecord
    validates :name, :application, presence: true

    belongs_to :application, class_name: 'Doorkeeper::Application'
    has_one :organisation_memberships, as: :member, inverse_of: :member, class_name: 'Membership', dependent: :destroy
    has_one :organisation, through: :organisation_memberships, source: :group, source_type: 'Organisation'
    has_many :memberships, as: :group, inverse_of: :group, dependent: :destroy
    has_many :members, through: :memberships, source_type: 'User'
    has_many :invitations, as: :group, inverse_of: :group

    def owners
      User.where.has { |u|
        (u.id.in organisation&.owners&.select(:id)).or(
            u.id.in members.where(memberships: { owner: true }).select(:id)
        )
      }.distinct
    end
  end
end
