module BeachApiCore
  class Message < ApplicationRecord
    belongs_to :chat
    belongs_to :sender, class_name: 'BeachApiCore::User'
    has_many :messages_users, inverse_of: :message

    default_scope { order created_at: :desc }

    validates :chat, :sender, :message, presence: true

    def read(user)
      messages_users.find_by(user: user).read
    end
  end
end
