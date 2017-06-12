require 'rails_helper'

module BeachApiCore
  RSpec.describe Chat::MessagesUser, type: :model do
    subject { build(:messages_user) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :user
      should validate_presence_of :message
    end
  end
end
