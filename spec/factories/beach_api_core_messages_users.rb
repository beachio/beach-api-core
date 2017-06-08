FactoryGirl.define do
  factory :messages_user, class: 'BeachApiCore::MessagesUser' do
    user { build(:user) }
    message { build(:message, :with_chat, sender: user) }
    read { false }
  end
end
