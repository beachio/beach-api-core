module BeachApiCore
  class User < ApplicationRecord
    include Concerns::Downcasable
    include Concerns::UserConfirm
    include Concerns::UserRoles
    include Concerns::UserPermissions

    has_one :profile, inverse_of: :user, dependent: :destroy, class_name: 'BeachApiCore::Profile'
    has_many :applications, as: :owner, class_name: 'Doorkeeper::Application'
    has_many :favourites, inverse_of: :user, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: {
        with: /\A(|(([a-z0-9]+_+)|([a-z0-9]+\-+)|([a-z0-9]+\.+)|([a-z0-9]+\++))*[a-z0-9]+@(([a-z0-9]+\-+)|([a-z0-9]+\.))*[a-z0-9]{1,63}\.[a-z]{2,6})\z/i },
              if: proc { errors[:email].empty? }
    validates :username, presence: true, uniqueness: true
    validates :profile, :status, presence: true

    has_many :invitations

    has_many :memberships, as: :member, inverse_of: :member, dependent: :destroy

    has_many :organisation_memberships, -> { where(group_type: 'BeachApiCore::Organisation') },
             as: :member, inverse_of: :member, class_name: 'BeachApiCore::Membership'
    has_many :organisations, through: :organisation_memberships, source: :group, source_type: 'BeachApiCore::Organisation'

    has_many :team_memberships, -> { where(group_type: 'BeachApiCore::Team') },
             as: :member, inverse_of: :member, class_name: 'BeachApiCore::Membership'
    has_many :teams, through: :team_memberships, source: :group, source_type: 'BeachApiCore::Team'

    has_secure_password
    acts_as_downcasable_on [:email, :username]

    accepts_nested_attributes_for :profile
    accepts_nested_attributes_for :organisation_memberships, allow_destroy: true, reject_if: proc { |attr| attr[:group_id].blank? }
    accepts_nested_attributes_for :memberships, allow_destroy: true
    accepts_nested_attributes_for :assignments, allow_destroy: true

    after_initialize :generate_profile
    before_validation :generate_username
    after_initialize :set_defaults

    delegate :first_name, :last_name, to: :profile

    enum status: [:active, :invitee]

    class << self
      def search(term)
        joins(:profile)
          .where("beach_api_core_users.email ILIKE :term OR beach_api_core_users.username ILIKE :term OR \
            beach_api_core_profiles.first_name ILIKE :term OR beach_api_core_profiles.last_name ILIKE :term",
             term: "%#{term.downcase}%")
      end
    end

    private

    def set_defaults
      self.status ||= :active
    end

    def generate_profile
      self.profile ||= build_profile(user: self)
    end

    def generate_username
      return if email.blank? || username.present?
      self.username = $1 if email.match(/\A(.*)@/)
    end
  end
end
