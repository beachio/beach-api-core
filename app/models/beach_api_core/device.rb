module BeachApiCore
  class Device < ApplicationRecord
    belongs_to :user

    before_create :set_token

    validates_presence_of :name

    private
      def set_token
        self.token = SecureRandom.hex if !token
      end
  end
end
