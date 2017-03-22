module BeachApiCore
  class Invitation < ApplicationRecord
    validates :email, :group, :user, presence: true

    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :invitee, class_name: 'BeachApiCore::User', autosave: true
    belongs_to :group, polymorphic: true

    attr_accessor :first_name, :last_name

    before_validation :set_invitee, on: :create
    after_destroy :destroy_invitee, if: 'invitee.invitee?'

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

    def destroy_invitee
      invitee.destroy
    end
  end
end
