require 'rails_helper'

module BeachApiCore
  RSpec.describe ChatsUser, type: :model do
    subject { build(:chats_user) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :chat
      should validate_presence_of :user
    end
  end
end
