module BeachApiCore
  class ChatsUser < ApplicationRecord
    belongs_to :chat, inverse_of: :chats_users
    belongs_to :user, inverse_of: :chats_users

    validates :chat, :user, presence: true
  end
end
