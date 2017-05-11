module BeachApiCore
  class Invitation < ApplicationRecord
    validates :email, :group, :user, :roles, presence: true
    validates :token, uniqueness: true

    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :invitee, class_name: 'BeachApiCore::User', autosave: true
    belongs_to :group, polymorphic: true
    has_many :invitation_roles, dependent: :destroy
    has_many :roles, through: :invitation_roles, class_name: 'BeachApiCore::Role'

    attr_accessor :first_name, :last_name

    before_validation :set_invitee, on: :create
    before_validation :set_token, on: :create, unless: 'token.present?'
    after_destroy :destroy_invitee, if: 'invitee&.invitee?'

    def accept!
      return unless [BeachApiCore::Team, BeachApiCore::Organisation].include?(group.class)
      transaction do
        group.memberships.create(member: invitee)
        role_ids.each { |role_id| invitee.assignments.create(role_id: role_id, keeper: group) }
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
    end

    def set_token
      self.token = loop do
        token = SecureRandom.urlsafe_base64
        break token unless self.class.where(token: token).exists?
      end
    end

    def destroy_invitee
      invitee.destroy
    end
  end
end
