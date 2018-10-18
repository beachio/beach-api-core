module BeachApiCore
  class User < ApplicationRecord
    include Concerns::UserConfirm
    include Concerns::UserRoles
    include Concerns::UserPermissions

    attr_accessor :require_confirmation, :require_current_password, :current_password, :confirmed

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
    has_many :user_accesses, inverse_of: :user, dependent: :destroy
    has_many :access_levels, through: :user_accesses
    has_many :organisation_accesses, -> { where(keeper_type: 'BeachApiCore::Organisation') },
             inverse_of: :user, class_name: 'BeachApiCore::UserAccess'

    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A(|(([a-z0-9]+_+)|([a-z0-9]+\-+)|([a-z0-9]+\.+)|([a-z0-9]+\++))*[a-z0-9]+@(([a-z0-9]+\-+)|([a-z0-9]+\.))*[a-z0-9]{1,63}\.[a-z]{2,6})\z/i },
              if: proc { errors[:email].empty? }
    validates :username, presence: true, uniqueness: true
    validates :profile, :status, presence: true
    validates :password_confirmation, :password, presence: true, if: :require_confirmation
    before_save :confirm_account, if: :confirmed
    after_save :send_broadcast_message, if: :scores_changed?
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
    accepts_nested_attributes_for :organisation_accesses, allow_destroy: true

    after_initialize :generate_profile
    before_validation :generate_username
    after_initialize :set_defaults
    after_create :set_sex_and_birth_date

    delegate :first_name, :last_name, :name, to: :profile

    enum status: %i(active invitee)
    SCORES_MESSAGE = "Your scores was changed."

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
    
    def token
      Doorkeeper::AccessToken.order("created_at DESC").find_by(resource_owner_id: id).token
    end

    def admin?
      role?(BeachApiCore::Role.admin)
    end

    def editor?
      role?(BeachApiCore::Role.editor)
    end

    def scientist?
      role?(BeachApiCore::Role.scientist)
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

    def set_sex_and_birth_date
      if self.profile.new_record?
        self.profile.user_id = self.id
        self.profile.sex = 'male'
        self.profile.birth_date = (Date.today - 25.year)
        self.profile.save!
      else
        self.profile.update_columns(sex: 'male', birth_date: (Date.today - 25.year))
      end
    end

    def confirm_account
      self.confirmed_at = Time.now
    end

    def send_broadcast_message
      tokens = Doorkeeper::AccessToken.where(:resource_owner_id => self.id)
      tokens.each do |token|
        application_message = BeachApiCore::Setting.scores_changed_message(keeper: token.application).nil? ? BeachApiCore::Setting.scores_changed_message(keeper: BeachApiCore::Instance.current) : BeachApiCore::Setting.scores_changed_message(keeper: token.application)
        BeachApiCore::UserChannel.broadcast_to(token, payload: {event: "userPointsChanged", value: self.scores, message: application_message.nil? ? SCORES_MESSAGE : application_message}, "user" => BeachApiCore::UserSerializer.new(self, root: :user))
      end
    end

    def generate_username
      return if email.blank? || username.present?
      uniq_number = BeachApiCore::User.maximum(:id).to_i + 1
      self.username = "#{Regexp.last_match[1]}-#{uniq_number}" if email =~ /\A(.*)@/
    end

    
  end
end
