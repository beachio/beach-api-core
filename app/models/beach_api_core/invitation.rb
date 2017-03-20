module BeachApiCore
  class Invitation < ApplicationRecord
    validates :email, :group, :user, presence: true

    belongs_to :user, class_name: 'BeachApiCore::User'
    belongs_to :group, polymorphic: true

    attr_accessor :first_name, :last_name

    before_validation :set_user, on: :create

    private

    def set_user
      self.user = BeachApiCore::User.create_with(
        first_name: first_name,
        last_name: last_name,
        status: BeachApiCore::User.statuses[:invitee]
      ).find_or_initialize_by(email: email)
    end
  end
end
