FactoryGirl.define do
  factory :chats_user, class: 'BeachApiCore::ChatsUser' do
    chat { build :chat }
    user { build :user }
  end
end
