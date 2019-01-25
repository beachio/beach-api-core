module BeachApiCore
  class User < ApplicationRecord
    include Concerns::UserConfirm
    include Concerns::UserRoles
    include Concerns::UserPermissions

    attr_accessor :require_confirmation, :require_current_password, :current_password, :confirmed, :application_id, :from_admin

    has_one :profile, inverse_of: :user, dependent: :destroy, class_name: 'BeachApiCore::Profile'
    has_many :applications, as: :owner, class_name: 'Doorkeeper::Application'

    has_many :favourites, inverse_of: :user, dependent: :destroy
    has_many :received_invitations,
             dependent: :destroy,
             foreign_key: :invitee_id,
             class_name: 'BeachApiCore::Invitation'
    has_many :invitations, dependent: :destroy

    has_many :memberships, as: :member, inverse_of: :member, dependent: :destroy

    has_many :devices

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
    has_many :scores, class_name: "BeachApiCore::Score", dependent: :destroy
    has_many :rewards, class_name: "BeachApiCore::Reward", as: :reward_to, dependent: :destroy
    has_many :messages_users, class_name: 'BeachApiCore::Chat::MessagesUser'
    has_many :owned_chats, class_name: 'BeachApiCore::Chat', as: :keeper, inverse_of: :keeper, dependent: :destroy
    has_many :user_accesses, inverse_of: :user, dependent: :destroy
    has_many :access_levels, through: :user_accesses
    has_many :organisation_accesses, -> { where(keeper_type: 'BeachApiCore::Organisation') },
             inverse_of: :user, class_name: 'BeachApiCore::UserAccess'
    has_many :invites, class_name: "BeachApiCore::Invite", dependent: :destroy

    validates :email,
              presence: true,
              uniqueness: true,
              format: { with: /\A(|(([a-z0-9]+_+)|([a-z0-9]+\-+)|([a-z0-9]+\.+)|([a-z0-9]+\++))*[a-z0-9]+@(([a-z0-9]+\-+)|([a-z0-9]+\.))*[a-z0-9]{1,63}\.[a-z]{2,6})\z/i },
              if: proc { errors[:email].empty? }
    validates :username, presence: true, uniqueness: true
    validates :profile, :status, presence: true
    validates :password_confirmation, :password, presence: true, if: :require_confirmation
    validate  :check_application_for_admin, if: :from_admin, on: [:create]
    before_save :confirm_account, if: :confirmed
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
    after_create :send_email_confirmation, if: :from_admin

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

    def find_or_create_application_token(application)
      Doorkeeper::AccessToken.find_or_create_for(application,
                                                 id,
                                                 Doorkeeper::OAuth::Scopes.from_string('password'),
                                                 Doorkeeper.configuration.access_token_expires_in,
                                                 Doorkeeper.configuration.refresh_token_enabled?)
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

    def check_application_for_admin
      self.errors.add :application_id, "Can't be empty" if self.application_id.nil? || self.application_id.empty? || Doorkeeper::Application.find_by(id: self.application_id).nil?
    end

    def send_email_confirmation
      application = Doorkeeper::Application.find_by(id: self.application_id)
      BeachApiCore::UserMailer.register_confirm(application, self, true).deliver_later if !application.nil? ||
          !BeachApiCore::Setting.client_domain(keeper: application).nil? ||
          !BeachApiCore::Setting.noreply_from(keeper: application).nil?
    end

    def confirm_account
      self.confirmed_at = Time.now
    end

    def generate_username
      return if email.blank? || username.present?
      uniq_number = BeachApiCore::User.maximum(:id).to_i + 1
      self.username = "#{Regexp.last_match[1]}-#{uniq_number}" if email =~ /\A(.*)@/
    end

    
  end
end
