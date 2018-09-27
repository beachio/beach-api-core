module BeachApiCore
  class Invitation < ApplicationRecord
    validates :email, :group, :user, :roles, presence: true
    validates :token, uniqueness: true

    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :invitee, class_name: 'BeachApiCore::User', autosave: true
    belongs_to :group, polymorphic: true
    has_many :invitation_roles, dependent: :destroy
    has_many :roles, through: :invitation_roles, class_name: 'BeachApiCore::Role'

    attr_accessor :first_name, :last_name, :application

    before_validation :set_invitee, on: :create
    before_validation :set_token, on: :create, unless: -> { token.present? }
    after_destroy :destroy_invitee, if: -> { invitee&.invitee? }

    def accept!
      return unless [BeachApiCore::Team, BeachApiCore::Organisation].include?(group.class)
      transaction do
        group.memberships.create(member: invitee)
        role_ids.each { |role_id| invitee.assignments.create(role_id: role_id, keeper: group) if invitee.assignments.where(:role_id => role_id, keeper: group).empty? }
        scores = user.scores + 500
        token = find_or_create_doorkeeper_token(user.id, group.application)
        user.update_attribute(:scores, user.scores + 500) if invitee.invitee?
        BeachApiCore::Webhook.notify('scores_achieved', 'BeachApiCore::User', user.id, token.id, scores) if invitee.invitee?
        invitee.active!
        destroy!
      end
    end

    private

    def set_invitee
      self.invitee = BeachApiCore::User.create_with(
          status: BeachApiCore::User.statuses[:invitee],
          password: SecureRandom.hex,
          profile_attributes: {
              first_name: first_name,
              last_name: last_name
          }
      ).find_or_initialize_by(email: email)
      check_mail_config
      self.errors.add :wrong, 'group_type', '. Group type should be one of: Team, Organisation' unless [BeachApiCore::Team, BeachApiCore::Organisation].include?(group.class)
      self.errors.add :wrong, 'group' if group.nil?
      return unless errors.blank?
      if no_membership
        role_ids = get_roles
        roles = BeachApiCore::Role.where(id: role_ids).pluck(:name)
        self.errors.add :wrong, 'permissions for indicated team' if roles.empty?
        self.errors.add :wrong, 'permissions for indicated team' unless (roles - ["admin", "developer"]).empty?
      end
      self.errors.add :wrong, 'application.' if application.id != group.application.id
    end

    def get_roles
      app_roles = self.user.assignments.where(keeper: group.application).pluck(:role_id)
      if app_roles.any?
        app_roles
      else
        self.user.assignments.where(keeper: BeachApiCore::Instance.current).pluck(:role_id)
      end
    end

    def no_membership
      user.memberships.where(:group_type => group.class.to_s, :group_id => group.id).empty?
    end

    def check_mail_config
      self.errors.add :wrong, 'application. There are no client_domain setting for current application' if BeachApiCore::Setting.client_domain(keeper: application).nil?
      self.errors.add :wrong, 'application. There are no noreply_from setting for current application' if BeachApiCore::Setting.noreply_from(keeper: application).nil?
    end

    def set_token
      self.token = loop do
        token = SecureRandom.urlsafe_base64
        break token unless self.class.where(token: token).exists?
      end
    end

    def find_or_create_doorkeeper_token(user_id, application)
      Doorkeeper::AccessToken.find_or_create_for(application,
                                                 user_id,
                                                 Doorkeeper::OAuth::Scopes.from_string('password'),
                                                 Doorkeeper.configuration.access_token_expires_in,
                                                 Doorkeeper.configuration.refresh_token_enabled?)
    end

    def destroy_invitee
      invitee.destroy
    end
  end
end