FactoryGirl.define do
  factory :chats_user, class: 'BeachApiCore::Chat::ChatsUser' do
    chat { build :chat }
    user { build :user }
  end
end
