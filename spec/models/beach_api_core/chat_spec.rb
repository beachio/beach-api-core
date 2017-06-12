require 'rails_helper'

module BeachApiCore
  RSpec.describe Chat, type: :model do
    subject { build(:chat, :with_chats_users) }

    it 'should be valid with factory attributes' do
      expect(subject).to be_valid
    end
    it 'should have basic validations' do
      should validate_presence_of :keeper
    end

    it 'should validate users uniqueness' do
      subject.chats_users << build(:chats_user, user: subject.chats_users.first.user)
      expect(subject).not_to be_valid
    end
  end
end
