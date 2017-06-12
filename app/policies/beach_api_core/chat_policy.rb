module BeachApiCore
  class ChatPolicy < ApplicationPolicy
    def add_recipient?
      record.keeper == user || record.keeper == application
    end

    def read?
      chat_participant?
    end

    alias index? read?
    alias create? read?

    private

    def chat_participant?
      record.users.include?(user)
    end
  end
end
