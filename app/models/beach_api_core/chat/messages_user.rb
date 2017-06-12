module BeachApiCore
  class Chat::MessagesUser < ApplicationRecord
    belongs_to :user, inverse_of: :messages_users
    belongs_to :message, inverse_of: :messages_users

    after_initialize :set_defaults

    validates :user, :message, presence: true

    private

    def set_defaults
      self.read ||= false
    end
  end
end
