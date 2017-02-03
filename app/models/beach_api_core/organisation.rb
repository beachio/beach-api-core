module BeachApiCore
  class Organisation < ApplicationRecord
    validates :name, :application, presence: true

    belongs_to :application, class_name: 'Doorkeeper::Application'
    has_many :memberships, as: :group, inverse_of: :group
    has_many :users, through: :memberships, source: :member, source_type: 'BeachApiCore::User'
    has_many :teams, through: :memberships, source: :member, source_type: 'BeachApiCore::Team'
    has_many :invitations, as: :group, inverse_of: :group

    def owners
      users.where(Membership.table_name => { owner: true })
    end
  end
end
