module BeachApiCore
  class User < ApplicationRecord
    include Concerns::UserConfirm
    include Concerns::UserRoles
    include Concerns::UserPermissions

    attr_accessor :require_confirmation, :require_current_password, :current_password

    has_one :profile, inverse_of: :user, dependent: :destroy, class_name: 'BeachApiCore::Profile'
    has_many :applications, as: :owner, class_name: 'Doorkeeper::Application'
    has_many :favourites, inverse_of: :user, dependent: :destroy
    has_many :received_invitations,
             dependent: :destroy,
             foreign_key: :invitee_id,
             class_name: 'BeachApiCore::Invitation'
    has_many :invitations, dependent: :destroy

    has_many :memberships, as: :member, inverse_of: :member, dependent: :destroy

    has_many :organisation_memberships, -> { where(group_type: 'BeachApiCore::Organisation') },
             as: :member, inverse_of: :member, class_name: 'BeachApiCore::Membership'
    has_many :organisations,
             through: :organisation_memberships,
             source: :group,
             source_type: 'BeachApiCore::Organisation'

    has_many :team_memberships, -> { where(group_type: 'BeachApiCore::Team') },
             as: :member, inverse_of: :member, class_name: 'BeachApiCore::Membership'
    has_many :teams, through: :team_memberships, source: :group, source_type: 'BeachApiCore::Team'
    has_many :user_preferences, dependent: :destroy

    has_many :projects, class_name: 'BeachApiCore::Project', inverse_of: :user, dependent: :destroy
    has_many :entities, inverse_of: :user, dependent: :destroy
    has_many :interactions, inverse_of: :user, dependent: :destroy
    has_many :chats_users, class_name: 'BeachApiCore::Chat::ChatsUser', inverse_of: :user
    has_many :chats, through: :chats_users
    has_many :messages_users, class_name: 'BeachApiCore::Chat::MessagesUser'
    has_many :owned_chats, class_name: 'BeachApiCore::Chat', as: :keeper, inverse_of: :keeper, dependent: :destroy

    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A(|(([a-z0-9]+_+)|([a-z0-9]+\-+)|([a-z0-9]+\.+)|([a-z0-9]+\++))*[a-z0-9]+@(([a-z0-9]+\-+)|([a-z0-9]+\.))*[a-z0-9]{1,63}\.[a-z]{2,6})\z/i },
              if: proc { errors[:email].empty? }
    validates :username, presence: true, uniqueness: true
    validates :profile, :status, presence: true
    validates :password_confirmation, presence: true, if: :require_confirmation
    validates :current_password, presence: true, if: :require_current_password
    validate :correct_current_password, if: :require_current_password

    has_secure_password
    acts_as_downcasable_on :email, :username
    acts_as_strippable_on :email, :username

    accepts_nested_attributes_for :profile
    accepts_nested_attributes_for :organisation_memberships,
                                  allow_destroy: true, reject_if: proc { |attr| attr[:group_id].blank? }
    accepts_nested_attributes_for :team_memberships, allow_destroy: true
    accepts_nested_attributes_for :assignments, allow_destroy: true
    accepts_nested_attributes_for :user_preferences, allow_destroy: true

    after_initialize :generate_profile
    before_validation :generate_username
    after_initialize :set_defaults

    delegate :first_name, :last_name, :name, to: :profile

    enum status: %i(active invitee)

    class << self
      def search(term)
        joins(:profile)
          .where("beach_api_core_users.email ILIKE :term OR beach_api_core_users.username ILIKE :term OR \
            beach_api_core_profiles.first_name ILIKE :term OR beach_api_core_profiles.last_name ILIKE :term",
                 term: "%#{term.downcase}%")
      end
    end

    def confirmed?
      confirmed_at.present?
    end

    def display_name
      first_name.present? ? first_name : username
    end

    private

    def correct_current_password
      return if User.find(id).authenticate(current_password)
      errors.add(:current_password, 'Incorrect current password')
    end

    def set_defaults
      self.status ||= :active
    end

    def generate_profile
      self.profile ||= build_profile(user: self)
    end

    def generate_username
      return if email.blank? || username.present?
      uniq_number = BeachApiCore::User.maximum(:id).to_i + 1
      self.username = "#{Regexp.last_match[1]}-#{uniq_number}" if email =~ /\A(.*)@/
    end
  end
end
