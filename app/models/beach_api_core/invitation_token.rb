module BeachApiCore
  class InvitationToken < ApplicationRecord
    belongs_to :user
    belongs_to :entity, polymorphic: true

    validates :user, :entity, :expire_at, presence: true
    validates :token, presence: true, uniqueness: true

    before_validation :set_expire_at, :generate_token

    private

    def generate_token
      self.token = loop do
        token = SecureRandom.urlsafe_base64
        break token unless self.class.where(token: token).exists?
      end
    end

    def set_expire_at
      self.expire_at ||= Time.now.utc + 100.years
    end
  end
end
