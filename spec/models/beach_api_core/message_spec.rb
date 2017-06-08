require 'rails_helper'

module BeachApiCore
  RSpec.describe Message, type: :model do
    subject { build(:message, :with_chat) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :chat
      should validate_presence_of :sender
      should validate_presence_of :message
    end
  end
end
