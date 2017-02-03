module BeachApiCore
  class Organisation < ApplicationRecord
    validates :name, :application, presence: true

    belongs_to :application, class_name: 'Doorkeeper::Application'
    has_many :memberships, as: :group, inverse_of: :group
    has_many :users, through: :memberships, source: :member, source_type: 'User'
    has_many :teams, through: :memberships, source: :member, source_type: 'Team'
    has_many :invitations, as: :group, inverse_of: :group

    def owners
      users.where(memberships: { owner: true })
    end
  end
end
