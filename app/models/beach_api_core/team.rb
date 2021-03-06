module BeachApiCore
  class Team < ApplicationRecord
    validates :name, :application, presence: true

    belongs_to :application, class_name: 'Doorkeeper::Application'
    has_one :organisation_membership, as: :member, class_name: 'BeachApiCore::Membership', dependent: :destroy
    has_one :organisation, through: :organisation_membership, source: :group, source_type: 'BeachApiCore::Organisation'
    has_many :memberships, as: :group, inverse_of: :group, dependent: :destroy
    has_many :members, through: :memberships, source_type: 'BeachApiCore::User'
    has_many :invitations, as: :group, inverse_of: :group

    def owners
      User.where.has do |u|
        (u.id.in organisation&.owners&.select(:id)).or(
          u.id.in(members.where(Membership.table_name => { owner: true }).select(:id))
        )
      end.distinct
    end
  end
end
