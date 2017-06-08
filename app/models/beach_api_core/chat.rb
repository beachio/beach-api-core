module BeachApiCore
  class Chat < ApplicationRecord
    has_many :chats_users, inverse_of: :chat
    has_many :users, through: :chats_users
    has_many :messages, inverse_of: :chat
    belongs_to :keeper, polymorphic: true

    accepts_nested_attributes_for :chats_users

    validates :keeper, presence: true
    validate :validate_user_uniqueness

    def add_recipient(recipient)
      chats_users.build(user: recipient)
    end

    def last_message
      messages.first
    end

    private

    def validate_user_uniqueness
      user_ids = chats_users.map(&:user)
      return if user_ids.uniq.length == user_ids.length
      errors.add(:users, :taken)
    end
  end
end
