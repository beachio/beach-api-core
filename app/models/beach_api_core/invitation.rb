module BeachApiCore
  class Invitation < ApplicationRecord
    validates :email, :group, :user, :role, presence: true
    validates :token, uniqueness: true

    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :invitee, class_name: 'BeachApiCore::User', autosave: true
    belongs_to :role, class_name: 'BeachApiCore::Role'
    belongs_to :group, polymorphic: true

    attr_accessor :first_name, :last_name

    before_validation :set_invitee, on: :create
    before_validation :set_token, on: :create, unless: 'token.present?'
    after_destroy :destroy_invitee, if: 'invitee&.invitee?'

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
