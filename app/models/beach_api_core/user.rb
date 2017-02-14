module BeachApiCore
  class User < ApplicationRecord
    include Concerns::Downcasable
    include Concerns::UserConfirm
    include Concerns::UserRoles

    has_one :profile, inverse_of: :user, dependent: :destroy, class_name: 'BeachApiCore::Profile'
    has_many :applications, as: :owner, class_name: 'Doorkeeper::Application'
    has_many :favourites, inverse_of: :user, dependent: :destroy

    validates :email, presence: true, uniqueness: true, format: {
        with: /\A(|(([a-z0-9]+_+)|([a-z0-9]+\-+)|([a-z0-9]+\.+)|([a-z0-9]+\++))*[a-z0-9]+@(([a-z0-9]+\-+)|([a-z0-9]+\.))*[a-z0-9]{1,63}\.[a-z]{2,6})\z/i },
              if: proc { errors[:email].empty? }
    validates :username, presence: true, uniqueness: true
    validates :profile, presence: true

    has_many :invitations

    has_one :organisation_membership, -> { where(group_type: 'BeachApiCore::Organisation') }, as: :member, inverse_of: :member,
            class_name: 'BeachApiCore::Membership', dependent: :destroy
    has_one :organisation, through: :organisation_membership, source: :group, source_type: 'BeachApiCore::Organisation'
    has_many :memberships, -> { where(group_type: 'BeachApiCore::Team') }, as: :member, inverse_of: :member, dependent: :destroy
    has_many :teams, through: :memberships, source: :group, source_type: 'BeachApiCore::Team'

    has_secure_password
    acts_as_downcasable_on [:email, :username]

    accepts_nested_attributes_for :profile
    accepts_nested_attributes_for :organisation_membership, allow_destroy: true, reject_if: proc { |attr| attr[:group_id].blank? }
    accepts_nested_attributes_for :memberships, allow_destroy: true

    before_validation :generate_profile, on: :create
    before_validation :generate_username

    private

    def generate_profile
      self.profile ||= build_profile(user: self)
    end

    def generate_username
      return if email.blank? || username.present?
      self.username = $1 if email.match(/\A(.*)@/)
    end
  end
end
